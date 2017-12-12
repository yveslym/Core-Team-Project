//
//  HomeViewController.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import KeychainSwift

class HomeViewController: UIViewController, plaidDelegate {
   
    // MARK: Properties
    let stack = CoreDataStack.instance
    
    weak var delegate : plaidDelegate?
    var dayExpenses = [DayExpense]() {
        didSet{
            dayExpenses.sort { $0.date < $1.date }
            currentMonthCollectionView.reloadData()
        }
    }
    
    var transactions = [Transaction]() {
        didSet {
            if transactions.count > 0 {
                shouldUpdateUI(true)
                currentMonthCollectionView.reloadData()
                
                let histo = sortTransactions(transactions: transactions)
                print("**************************************")
                for (date,trans) in histo {
                    print("\n")
                    print("Key", date, "Value: ", trans)
                    dayExpenses.append(DayExpense(date: date, transactions: trans))
                }
                print("**************************************")
                dayExpenses.forEach({ (expense) in
                    print("IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII")
                    print(expense)
                })
            }
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var currentMonthCollectionView: UICollectionView!
    
    // MARK: IBActions
    
    @IBAction func addBankAccountButtonPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: Identifiers.homeToAddBank, sender: nil)
        delegate?.presentPlaidLink()
    }
    
//    @IBAction func unwindFromLinkBankAccount(_ sender: UIStoryboardSegue) {
//        if sender.source is LinkBankAcountViewController {
//            if let linkBankAcountViewController = sender.source as? LinkBankAcountViewController,
//                let newTransactions = linkBankAcountViewController.transactions {
//
//                transactions.append(contentsOf: newTransactions)
//                print("shouldUpdateUI(Bool) about to be called")
//                shouldUpdateUI(true)
//                print("Did call shouldUpdateUI(bool)")
//            }
//        }
//    }
    
    // MARK: Methods
    
    override func reloadInputViews() {
        if stack.privateContext.hasChanges{
            stack.saveTo(context: stack.privateContext)
            self.transactions = {
                let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext) as? [Transaction]
                return record!
            }()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonthCollectionView.delegate = self
        currentMonthCollectionView.dataSource = self
        shouldUpdateUI(false)
        delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        print("HOMEVIEW TANSCOUNT------------------------========================------------------------")

        self.transactions = {
            let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext)
            let trans = record as? [Transaction]
            return trans!
        }()
    }
    
    func shouldUpdateUI(_ bool: Bool) {
        if bool {
            currentMonthCollectionView.isHidden = false
            currentMonthCollectionView.backgroundColor = self.view.backgroundColor
            currentMonthCollectionView.reloadData()
            monthLabel.isHidden = false
        } else {
            currentMonthCollectionView.isHidden = true
            monthLabel.isHidden = true
        }
    }
    
    func sortTransactions(transactions: [Transaction]) -> [String: [Transaction]] {
        var dict = [String: [Transaction]]()
        
        transactions.forEach { (trans) in
            if let _ = dict[trans.date!] {
                dict[trans.date!]!.append(trans)
            }else {
                dict[trans.date!] = [trans]
            }
        }
        
        return dict
    }
    
}

// MARK: - Collection View DataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let date = dayExpenses[index].date
        let expense = dayExpenses[index].totalAmount
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.currentMonthCell,
                                                      for: indexPath) as! DailyExpenseCell
        cell.dateLabel.text = date
        cell.expenseLabel.text = String(describing: expense)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayExpenses.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - Collection View Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("* Selected item at Row * ", indexPath.row)
        print("items at cell ")
        
        dayExpenses[indexPath.row].listedTransactions.forEach { (trans) in
            print("\n%%%", trans)
        }
    }
}
