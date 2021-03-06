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
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var view1: UIView!
    
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
    
    
    func setUpView(){
        self.mainStack.alignment = .fill
        self.mainStack.distribution = .fill
        self.view1.layer.cornerRadius = 15.0
        self.view1.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            self.view1.heightAnchor.constraint(equalTo: self.mainStack.heightAnchor, multiplier: 0.75)
            
            ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
//        tableView.delegate = self
//        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
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

//extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return Transaction.numberOfMonth(transaction: self.transactions).count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChartTableViewCell
//
//        let month = Transaction.numberOfMonth(transaction: self.transactions)
//        let index = indexPath.row
//
//        let totalExp = Transaction.totalExpensesByMonth(month: month[index], transaction: self.transactions)
//        let totalIncome = Transaction.totalIncomeByMonth(month: month[index], transaction: transactions)
//        let summary = totalExp + totalIncome
//
//
//
//        cell.expenses.text = String(totalExp)
//        cell.income.text = String(totalIncome)
//        cell.summary.text = String(summary)
//        //cell.delegate = self
//        cell.month.text = month[index]
//        //cell.delegate.chartConfiguration(month: month[index], cell: cell, transaction: transactions)
//
//
//
//        return cell
//    }
//}
extension ExpensesViewController: UICollectionViewDelegate, UICollectionViewDataSource, delegateChart{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Transaction.numberOfMonth(transaction: self.transactions).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExpensesCollectionViewCell
        
        let month = Transaction.numberOfMonth(transaction: self.transactions)
        let index = indexPath.row
        
        let totalExp = Transaction.totalExpensesByMonth(month: month[index], transaction: self.transactions)
        let totalIncome = Transaction.totalIncomeByMonth(month: month[index], transaction: transactions)
        let summary = totalExp + totalIncome
        
        
        cell.expenses.text = String(totalExp)
        cell.incomes.text = String(totalIncome)
        cell.summary.text = String(summary)
        cell.configureCollectionView()
        cell.month.text = month[index]
        cell.delegate = self
        cell.delegate.chartConfiguration(month: month[index], cell: cell, transaction: self.transactions)
        
        
        return cell
    }
    
    func chartConfiguration(month:String, cell: ExpensesCollectionViewCell, transaction:[Transaction]){
        
        
        let dayOfWeek = Calendar.allDayOfWeek()
        var expChart = [(String,Double)]()
        
        dayOfWeek.forEach {
            let totalExpense = Transaction.totalExpensesBydayOfWeek(dayKey: $0, monthKey: month, transaction: transaction)
            expChart.append(($0, totalExpense))
        }
        
                let chartConfig = BarsChartConfig(
                    valsAxisConfig: ChartAxisConfig(from: 10, to: 1000, by: 100)
                )

                let frame = CGRect(x: cell.chartView.frame.origin.x, y:  cell.chartView.frame.origin.y, width: cell.chartView.frame.width, height: cell.chartView.frame.height)

                let chart = BarsChart(
                    frame: frame,
                    chartConfig: chartConfig,
                    xTitle: "X axisxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                    yTitle: "Y axisyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
                    bars: expChart,
                    color: UIColor.red,
                    barWidth: 20//cell.chartView.frame.width * 0.25
                )
        
//                let chartConfig = ChartConfigXY(
//                    xAxisConfig: ChartAxisConfig(from: 2, to: 14, by: 2),
//                    yAxisConfig: ChartAxisConfig(from: 0, to: 14, by: 2)
//                )
//
//                let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
//
//                let chart = LineChart(
//                    frame: frame,
//                    chartConfig: chartConfig,
//                    xTitle: "X axis",
//                    yTitle: "Y axis",
//                    lines: [
//                        (chartPoints: [(2.0, 10.6), (4.2, 5.1), (7.3, 3.0), (8.1, 5.5), (14.0, 8.0)], color: UIColor.red),
//                        (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.blue)
//                    ]
//                )
        
        //        self.view.addSubview(chart.view)
        
        
        
        chart.view.trailingAnchor.constraint(equalTo: cell.chartView.trailingAnchor, constant: 0)
        
        chart.view.leadingAnchor.constraint(equalTo: cell.chartView.leadingAnchor, constant: 0)
        
        chart.view.topAnchor.constraint(equalTo: cell.chartView.topAnchor, constant: 0)

        chart.view.bottomAnchor.constraint(equalTo: cell.chartView.bottomAnchor, constant: 0)

         cell.chartView.addSubview(chart.view)
    }
    
}










