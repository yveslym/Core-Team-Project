//
//  MonthlyExpenseSummaryViewController.swift
//  Core-Project
//
//  Created by Yveslym on 12/26/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class MonthlyExpenseSummaryViewController: UIViewController {

    // - MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var mainStack: UIStackView!

//    @IBOutlet weak var view3: UIView!

    
    
    // - MARK: Properties
    let stack = CoreDataStack.instance
    
    
    var transactions = [Transaction]() {
        didSet {
            DispatchQueue.main.async {
                //self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func configureViewController(){
        self.mainStack.distribution = .fill
        
        NSLayoutConstraint.activate([
            
            
//            view1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            view2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
//            view3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
//            expenseStack.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.30),
//            monthStack.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.50),
//            dayStackView.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.20),
//            tableView.leadingAnchor.constraint(equalTo: tableTack.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: tableTack.trailingAnchor),
//            tableView.topAnchor.constraint(equalTo: tableTack.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: tableTack.bottomAnchor)
            
            ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureViewController()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.transactions = {
            let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext)
            let trans = record as? [Transaction]
            
            return trans!
        }()
    }

    
}

extension MonthlyExpenseSummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Transaction.numberOfMonth(transaction: self.transactions).count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonthlyExpensesCollectionViewCell
        
      
        let _month = Transaction.numberOfMonth(transaction: self.transactions)
        let month = _month[indexPath.row]
        
        let totalExpense = Transaction.totalExpensesByMonth(month: month, transaction: self.transactions)
        let totalIncome = Transaction.totalIncomeByMonth(month: month, transaction: self.transactions)
        
        let summary = totalExpense + totalIncome
        
        
        let expenseByCategory = Transaction.sortedExpensesByCategoryByMonth(month: month, transaction: self.transactions)
        print(expenseByCategory)
        
    
        
        
        // update collection view
        
        cell.category.text = expenseByCategory[0].key
         cell.category2.text = expenseByCategory[1].key
         cell.category3.text = expenseByCategory[2].key
        
        cell.expense.text = String ("$ \(totalExpense)")
        cell.income.text = String ("$ \( -1 * totalIncome)")
        cell.month.text = month
        cell.summary.text = String(" $ \(-1 * summary.rounded())")
        cell.mostExpense.text =  String("$ \(expenseByCategory[0].value)")
         cell.mostExpense2.text =  String("$ \(expenseByCategory[1].value)")
         cell.mostExpense3.text =  String("$ \(expenseByCategory[2].value)")
        
        
        
        return cell
    }
    
}
























