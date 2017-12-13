//
//  ExpensesViewController.swift
//  Core-Project
//
//  Created by Yveslym on 12/15/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import SwiftCharts

class ExpensesViewController: UIViewController {
    
    
    // - MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    
    // - MARK: Properties
    let stack = CoreDataStack.instance
   
    
    var transactions = [Transaction]() {
        didSet {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.transactions = {
            let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext)
            let trans = record as? [Transaction]
            
            return trans!
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource, delegateChart{
    func chartConfiguration(month:String, cell: ChartTableViewCell, transaction:[Transaction]){
        
//         NSLayoutConstraint.activate([
//            
//            cell.chartStack.heightAnchor.constraint(equalTo: cell.mainStack.heightAnchor, multiplier: 0.40)
//            
//            ])
        
        
        let dayOfWeek = Calendar.allDayOfWeek()
        var expChart = [(String,Double)]()
        
        dayOfWeek.forEach {
            let totalExpense = Transaction.totalExpensesBydayOfWeek(dayKey: $0, monthKey: month, transaction: transaction)
            expChart.append(($0, totalExpense))
        }
    
//        let chartConfig = BarsChartConfig(
//            valsAxisConfig: ChartAxisConfig(from: 0, to: 1000, by: 100)
//        )
//
//        let frame = CGRect(x: cell.chartView.frame.origin.x, y:  cell.chartView.frame.origin.y, width: cell.chartView.frame.width, height: cell.chartView.frame.height)
//
//        let chart = BarsChart(
//            frame: frame,
//            chartConfig: chartConfig,
//            xTitle: "X axis",
//            yTitle: "Y axis",
//            bars: expChart,
//            color: UIColor.red,
//            barWidth: 30//cell.chartView.frame.width * 0.25
//        )
        
//        let chartConfig = ChartConfigXY(
//            xAxisConfig: ChartAxisConfig(from: 2, to: 14, by: 2),
//            yAxisConfig: ChartAxisConfig(from: 0, to: 14, by: 2)
//        )
//        
//        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
//        
//        let chart = LineChart(
//            frame: frame,
//            chartConfig: chartConfig,
//            xTitle: "X axis",
//            yTitle: "Y axis",
//            lines: [
//                (chartPoints: [(2.0, 10.6), (4.2, 5.1), (7.3, 3.0), (8.1, 5.5), (14.0, 8.0)], color: UIColor.red),
//                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.blue)
//            ]
//        )
//        
//        self.view.addSubview(chart.view)
//        
//        cell.chartView.addSubview(chart.view)
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return Transaction.numberOfMonth(transaction: self.transactions).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChartTableViewCell
    
        let month = Transaction.numberOfMonth(transaction: self.transactions)
        let index = indexPath.row
        
        let totalExp = Transaction.totalExpensesByMonth(month: month[index], transaction: self.transactions)
        let totalIncome = Transaction.totalIncomeByMonth(month: month[index], transaction: transactions)
        let summary = totalExp + totalIncome
        
        
        
        cell.expenses.text = String(totalExp)
        cell.income.text = String(totalIncome)
        cell.summary.text = String(summary)
        cell.delegate = self
        cell.month.text = month[index]
        cell.delegate.chartConfiguration(month: month[index], cell: cell, transaction: transactions)
        
        
        
        return cell
    }
    
   
}












