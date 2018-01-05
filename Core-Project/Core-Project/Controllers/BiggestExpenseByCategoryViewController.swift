//
//  BiggestExpenseByCategoryViewController.swift
//  Core-Project
//
//  Created by Yveslym on 12/28/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class BiggestExpenseByCategoryViewController: UIViewController {

    // - MARK: Properties
    let stack = CoreDataStack.instance
    var expenseByCategory: [(key: String, value: Double)]?
    var _month : String?
    
    var transactions = [Transaction]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    // - MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var month: UILabel!
    @IBOutlet weak var totalExpense: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            self.navigationController?.hidesBarsOnSwipe = true
           
        }
    

}

extension BiggestExpenseByCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenseByCategory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TBiggestExpenseByMonthableViewCell
        
        let category = self.expenseByCategory?[indexPath.row].key
        let expense = self.expenseByCategory?[indexPath.row].value ?? 0.0
        
        
        let arrayString = Array(category!)
        let _initCategory = ( "\(arrayString[0]) \(arrayString[1])")
        let initCategory = _initCategory.uppercased()
        
        let amount = self.expenseByCategory?.flatMap{$0.value}
        let totalAmount = amount?.reduce(0.0,+) ?? 0
        
        
        
        cell.category.text = category
        cell.expense.text = String("$ \(expense.rounded())")
        cell.categoryInitial.text = initCategory
        self.totalExpense.text = String("$\(totalAmount.rounded())")
        //self.month.text = self._month
        
        return cell
    }
    
    
}
