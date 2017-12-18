//
//  Transaction+CoreDataClass.swift
//
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, Decodable {

    public convenience required init(from decoder: Decoder) throws {

        enum TransactionKey: String,CodingKey{
            case transactions
            case location
            case category
            case amount
            case date
            case account_id
            case name
            case transaction_id
            enum AddressKey: String,CodingKey{
                case city
                case state
                case address
                case zip
            }

        }

        //guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let context = CoreDataStack.instance.privateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)


        let contenair = try decoder.container(keyedBy: TransactionKey.self)

        name = try contenair.decodeIfPresent(String.self, forKey: .name) ?? nil
        self.accountID = try contenair.decodeIfPresent(String.self, forKey: .account_id) ?? nil
        self.date = try contenair.decodeIfPresent(String.self, forKey: .date) ?? nil
        self.id = try contenair.decodeIfPresent(String.self, forKey: .transaction_id) ?? nil
        self.amount = (try contenair.decodeIfPresent(Double.self, forKey: .amount) ?? nil)!
        let category = try contenair.decodeIfPresent([String].self, forKey: .category) ?? nil
        if category != nil{
            if category!.count > 1{
                self.category = category?[1] ?? "Other"
                self.types = category?[0] ?? "Other"
            }
            else{
                self.category = category?[0]
            }
        }
        let locationContenair = try contenair.nestedContainer(keyedBy: TransactionKey.AddressKey.self, forKey: .location)

        self.city = try locationContenair.decodeIfPresent(String.self, forKey: .city) ?? nil
        self.state = try locationContenair.decodeIfPresent(String.self, forKey: .state) ?? nil
        self.address = try locationContenair.decodeIfPresent(String.self, forKey: .address) ?? nil
        self.zipCode = try locationContenair.decodeIfPresent(String.self, forKey: .zip) ?? nil

        let todate = self.date?.toDate()
        self.dayName = todate?.dayOfWeak()
        self.monthName = todate?.monthName()

    }
}
extension Transaction{
    convenience init(context: NSManagedObjectContext) {

        let entityDescription = NSEntityDescription.entity(forEntityName: "Transaction", in:
            context)!

        self.init(entity: entityDescription, insertInto: context)
    }
}

struct transactionOperation: Decodable{
    var transactions:[Transaction]
}

extension Transaction{

    // function to return array of transaction by day
    static func expenseByDayOfWeek( dayKey: String, monthKey: String, transaction: [Transaction]) -> [Transaction]{
        let trans = transaction.filter{return ($0.dayName == dayKey && $0.monthName == monthKey && $0.amount > 0.0)}
        return trans
    }

    static func incomeByDayOfWeek( dayKey: String, monthKey: String, transaction: [Transaction]) -> [Transaction]{
        let trans = transaction.filter{$0.dayName == dayKey && $0.monthName == monthKey && $0.amount < 0.0}
        return trans
    }

    /// function to return array of expenses transaction by month
    static func expensesByMonth(monthKey: String,transaction: [Transaction]) -> [Transaction]{
        let trans = transaction.filter {$0.monthName == monthKey && $0.amount > 0.0}
        return trans
    }
    /// function to return array of income transaction by month
    static func incomeByMonth(monthKey: String,transaction: [Transaction]) -> [Transaction]{
        let trans = transaction.filter {$0.monthName == monthKey && $0.amount < 0.0}
        return trans
    }

    /// function to return all of expences transaction by year
    static func expensesByYear(year: Int, transaction: [Transaction]) -> [Transaction]{
        let keyYear = String(year)
        let trans = transaction.filter {($0.date?.hasSuffix(keyYear))! && $0.amount > 0.0}
        return trans
    }
    /// function to return all of income transaction by year
    static func incomeByYear(year: Int, transaction: [Transaction]) -> [Transaction]{
        let keyYear = String(year)
        let trans = transaction.filter {($0.date?.hasSuffix(keyYear))! && $0.amount > 0.0}
        return trans
    }

    /// function to return monthly expenses
    static func totalExpensesByMonth(month: String, transaction: [Transaction]) -> Double{
        let expensesByMonth = Transaction.expensesByMonth(monthKey: month, transaction: transaction)
        let trans = expensesByMonth.flatMap {$0.amount}
        let totalAmount = trans.reduce(0.0, +)
        return totalAmount
    }

    /// function to return monthly income
    static func totalIncomeByMonth(month: String, transaction: [Transaction]) -> Double{
        let expensesByMonth = Transaction.incomeByMonth(monthKey: month, transaction: transaction)
        let trans = expensesByMonth.flatMap {$0.amount}
        let totalAmount = trans.reduce(0.0, +)
        return totalAmount
    }

    /// function to return total expenses by day of week
    static func totalExpensesBydayOfWeek(dayKey: String, monthKey: String, transaction: [Transaction]) -> Double{
        let dayExpenses = Transaction.expenseByDayOfWeek(dayKey: dayKey, monthKey: monthKey, transaction: transaction)
        let trans = dayExpenses.flatMap{$0.amount}
        let totalAmount = trans.reduce(0.0,+)
        return totalAmount
    }

    /// function to return total income by day of week
    static func totalIncomeBydayOfWeek(dayKey: String, monthKey: String, transaction: [Transaction]) -> Double{
        let dayExpenses = Transaction.incomeByDayOfWeek(dayKey: dayKey, monthKey: monthKey, transaction: transaction)
        let trans = dayExpenses.flatMap{$0.amount}
        let totalAmount = trans.reduce(0.0,+)
        return totalAmount
    }

    /// function to return total expense by year
    static func totalExpensesByYear(year: Int, transaction: [Transaction])-> Double{
        let trans = Transaction.expensesByYear(year: year, transaction: transaction)
        let expense = trans.flatMap{$0.amount}
        let totalAmount = expense.reduce (0.0, +)
        return totalAmount
    }

    /// function to return total income by year
    static func totalIncomeByYear(year: Int, transaction: [Transaction])-> Double{
        let trans = Transaction.incomeByYear(year: year, transaction: transaction)
        let expense = trans.flatMap{$0.amount}
        let totalAmount = expense.reduce (0.0, +)
        return totalAmount
    }

    static func isThisMonthEmpty(month: String, transaction: [Transaction]) -> Bool{
        let trans = transaction.filter{$0.monthName == month}
        if trans.first == nil{
            return true
        }
        else{
            return false
        }
    }
    static func numberOfMonth(transaction: [Transaction]) -> [String]{
        let month = transaction.flatMap{$0.monthName}
        let unique = Set(month)

        return Array(unique)
    }

    // return all category on the transaction array
    static func getAllTransactionCategory(transaction: [Transaction]) -> [String]{
        let categoryList = transaction.flatMap{ $0.category}
        let category = Set(categoryList)
        return Array(category)
    }
    
    // function to return all types of transaction array
    static func getAllTypeTransaction(transaction: [Transaction]) -> [String]{
        
        let typeList = transaction.flatMap {$0.types}
        let type = Set(typeList)
        return Array(type)
    }
    
    static func TransactionOfSameCategoty(category: String, transaction: [Transaction]) -> [Transaction]?{
        let filter = transaction.filter{ $0.category == category}
        return filter
    }
    
    // function to return a dictionary of key transaction and value amount of money sorted from the highest to the lowest
    static func sortedExpensesByCategoryByMonth(month: String, transaction: [Transaction]) -> [String: Double]{
        
        var sortedExpense = [String: Double]()
        
        let monthExpenses = Transaction.expensesByMonth(monthKey: month, transaction: transaction)
        
        monthExpenses.forEach{
            if sortedExpense[$0.category!]  == nil{
                sortedExpense[$0.category!] = $0.amount
            }
            else{
                sortedExpense[$0.category!] = sortedExpense[$0.category!]! + $0.amount
            }
        }
        let result = sortedExpense.sorted(by:{ $0.1 > $1.1})
        
        var sorted = [String: Double]()
        result.forEach{
            sorted[$0.key] = $0.value
        }
        return sorted
    }
    
   
  
}












