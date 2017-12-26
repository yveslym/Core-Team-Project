//
// Created by Yveslym on 12/22/17.
// Copyright (c) 2017 Yveslym. All rights reserved.
//
//

import Foundation

class FoodModel{

    // - MARK: Properties

    let age: Int?
    let sex: String?
    let income: Double?
    let region: String?

    // - MARK: Initializers

    init(){
        self.age = 0
        self.sex = nil
        self.income = 0.0
        self.region = nil
    }




    // - MARK: Methods

    /// method that return total expenses on food for a given month
    private func foodExpenses(by month: String, transaction: [Transaction]) -> [String: Double]?{

        var result = [String: Double]()
        let foodTransaction = transaction.filter{$0.tag == "Food" && $0.monthName == month}
        let expenses = transaction.flatMap{$0.amount}
        let amount = expenses.reduce(0.0, +)
        result[month] = amount
        return result
    }

    /// method to return an array food expenses by month
    public func monthlyFoodExpenses (transaction: [Transaction]) -> [[String: Double]]{

        let monthList = Transaction.numberOfMonth(transaction: transaction)
        var result = [[String: Double]]()

        monthList.forEach{
            let foodExpense = foodExpenses(by: $0, transaction: transaction)
            result.append(foodExpense!)
        }
        return result
    }

}

enum FoodPredefineModel{

    case age,sex,income,region

    enum AgePrediction: Int{
        case youngAdult = 29
        case adult = 49
        case semiSenior = 64
        case senior = 65

        func agePredifine() -> Double{

            switch (self){
            case .youngAdult:
                return 24.71

            case .adult:
                return 23.85

            case .semiSenior:
                return 21.14

            case .senior:
                return 14.71

            default:
                return 0.0
            }
        }


    }

    enum SexPrediction: String{
        case Male
        case Female
    }
    enum IncomePrediction: Double{
        case low = 30000.00
        case medium = 75000.00
        case high = 76000.00
    }
    enum RegionPrediction: String{
        case east
        case west
        case south
        case midwest
    }



}
