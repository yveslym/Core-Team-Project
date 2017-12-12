//
//  ViewController.swift
//  calendar api
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController, plaidDelegate {
    
    // - MARK: Properties
    
    let stack = CoreDataStack.instance
    let formatter = DateFormatter()
    var dayExpenses = [DayExpense]()
    var expDic = [String: Double]()
    var testCalendar = Calendar.current
    var monthSize: MonthSize? = nil
     let numberOfRows = 5
    
    
     var prePostVisibility: ((CellState, calendarViewCell?)->())?
    
    var transactionDetail : [Transaction]?
    
    var transactions = [Transaction]() {
        didSet {
            if transactions.count > 0 {
                shouldUpdateUI(true)
                //calendarView.reloadData()
                
                let histo = sortTransactions(transactions: transactions)
                
                for (date,trans) in histo {
                   
                    dayExpenses.append(DayExpense(date: date, transactions: trans))
                }
        
                dayExpenses.forEach { (dayExp) in
                    expDic[dayExp.date] = dayExp.totalAmount
                }
                

                DispatchQueue.main.async {
                    print("++++++++++ before reload data")
                    self.calendarView.reloadData()
                     print("------------------after reload data")
                }
                
            }
        }
    }
    
    
    
    
    // - MARK: IBOutlets
    weak var delegate: plaidDelegate!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableTack: UIStackView!

    // - MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        tableView.delegate = self
        tableView.dataSource = self
        //tableTack.addArrangedSubview(tableView)
        tableView.isHidden = true
        delegate = self
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
    }
        self.calendarView.minimumLineSpacing = 2
        self.calendarView.minimumInteritemSpacing = 2
}
    
    override func reloadInputViews() {
        if stack.privateContext.hasChanges{
            stack.saveTo(context: stack.privateContext)
            self.transactions = {
                let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext) as? [Transaction]
                return record!
            }()
        }
    }
    
    var firstRun = true
    
    override func viewDidAppear(_ animated: Bool) {
        print("HOMEVIEW TANSCOUNT------------------------========================------------------------")
        
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
    
    // - MARK: Methods
    
    func shouldUpdateUI(_ bool: Bool) {
        if bool {
            calendarView.isHidden = false
            calendarView.backgroundColor = self.view.backgroundColor
            calendarView.reloadData()
            monthLabel.isHidden = false
        } else {
            calendarView.isHidden = true
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
    
    // function to configure the calendar
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
        
       
    }
    
    // funtion to configure cell
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? calendarViewCell  else { return }
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        //handleCellTextColor(view: cell as? calendarViewCell, cellState: cellState)
        prePostVisibility?(cellState, cell as? calendarViewCell)
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
//        guard let myCustomCell = view as? calendarViewCell else {return }
//                switch cellState.selectedPosition() {
//                case .full:
//                    myCustomCell.backgroundColor = .green
//                case .left:
//                    myCustomCell.backgroundColor = .yellow
//                case .right:
//                    myCustomCell.backgroundColor = .red
//                case .middle:
//                    myCustomCell.backgroundColor = .blue
//                case .none:
//                    myCustomCell.backgroundColor = nil
//                }
//
//        if cellState.isSelected {
////            myCustomCell.selectedView.layer.cornerRadius =  13
////            myCustomCell.selectedView.isHidden = false
////        } else {
////            myCustomCell.selectedView.isHidden = true
//       }
        
    }
    
    
    func handleCellTextColor(view: calendarViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            view.day.textColor = UIColor.white
            
        } else {
            view.day.textColor = UIColor.gray
        }
    }
}

extension ViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -360, to: endDate)
        
        let parm =  ConfigurationParameters(startDate: startDate!, endDate: endDate, numberOfRows: self.numberOfRows)
       // let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate)
        
        return parm
    }
    
    
}

extension ViewController: JTAppleCalendarViewDelegate{
//    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//
//    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! calendarViewCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    

    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
       // handleCellConfiguration(cell: cell, cellState: cellState)
       

    }
    
    // function to setup the table view when a date has been seleted
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
        
        print("selected date ", cellState.date)
        
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: cellState.date)
        
        
        
        if self.transactionDetail?.first?.date == date{
                self.transactionDetail = nil
            
            UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options:UIViewAnimationOptions.transitionFlipFromBottom, animations: {
                 self.tableView.isHidden = true
                
            },completion:nil)
            
            
//            UIView.animate(withDuration: (1.0), animations: {
//                self.tableView.isHidden = true
//            })
        }
            
            else {
            
                self.transactionDetail = [Transaction]()
                self.transactions.forEach { (transaction) in
                    if transaction.date == date{
                        self.transactionDetail?.append(transaction)
                        }
                    }
            if self.transactionDetail?.count  != 0{
                
                UIView.animate(withDuration: (1.0), animations: {
                    self.tableView.isHidden = false
                })
            }
            else{
                UIView.animate(withDuration: (1.0), animations: {
                    self.tableView.isHidden = true
                })
            }
                }
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        // present the table view
//        if self.transactionDetail != nil{
//            if self.tableView.isHidden == false{
//
//                UIView.animate(withDuration: (0.3), animations: {
//                    self.tableView.isHidden = true
//                })
//            }
//
//        else{
//            UIView.animate(withDuration: (1.0), animations: {
//                self.tableView.isHidden = false
//            })
//        }
//
//    }
//        else{
//            UIView.animate(withDuration: (0.3), animations: {
//                self.tableView.isHidden = true
//            })
//        }
}
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let date = range.start
        let month = testCalendar.component(.month, from: date)
        
        let header: JTAppleCollectionReusableView
        if month % 2 > 0 {
            header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "WhiteSectionHeaderView", for: indexPath)
//            (header as! WhiteSectionHeaderView).title.text = formatter.string(from: date)
        } else {
            header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "PinkSectionHeaderView", for: indexPath)
           // (header as! PinkSectionHeaderView).title.text = formatter.string(from: date)
        }
        return header
    }
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let stride = calendarView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 10, y: 10, width: calendarView.frame.width - 5, height: calendarView.frame.height - 5)
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return monthSize
    }
    
    func configureVisibleCell(myCustomCell: calendarViewCell, cellState: CellState, date: Date) {
        myCustomCell.day.text = cellState.text
        if testCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.blue
        } else {
            myCustomCell.backgroundColor = .white
        }
        
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        
        
        if cellState.text == "1" {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: date)
            self.monthLabel.text = "\(month) \(cellState.text)"
        } else {
            self.monthLabel.text = ""
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! calendarViewCell
        
         //configureVisibleCell(myCustomCell: cell, cellState: cellState, date: date)
                configureCell(view: cell, cellState: cellState)
                if cellState.text == "1" {
                    formatter.dateFormat = "MMM"
                    let month = formatter.string(from: date)
                    cell.day.text = "\(month) \(cellState.text)"
                } else {
                    cell.day.text = cellState.text
                }
        formatter.dateFormat = "yyyy-MM-dd"
        let day = formatter.string(from: cellState.date)
        
        var todayExp = expDic[day]
        if todayExp != nil{
            todayExp?.round(.towardZero)
            
           
            print(cell.amount.text!)
            
            if (todayExp?.isLess(than: 0.0))!{
                
                todayExp?.negate()
                 cell.amount.text = "\(todayExp ?? 0.0)"
                cell.amount.textColor = UIColor(red: 28/255, green: 207/255, blue: 168/255, alpha: 1)
            }
            else{
                todayExp?.negate()
                cell.amount.textColor = UIColor(red: 255/255, green: 44/255, blue: 85/255, alpha: 1)
                 cell.amount.text = "\(todayExp ?? 0.0)"
            }
            
           
        }
        else{
            cell.amount.text = ""
        }
        
        //cell.layer.cornerRadius = 8
    
return cell
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if transactionDetail != nil{
        return self.transactionDetail!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailTableViewCell
        
        if self.transactionDetail != nil  {
        
        
        
            let transaction = self.transactionDetail![indexPath.row]
        
        
        cell.BankName.text = transaction.account?.name ?? ""
        cell.category.text = transaction.category
        cell.type.text = transaction.types
        cell.date.text = transaction.date
        cell.transactionName.text = transaction.name
        
        if transaction.amount.isLess(than: 0.0){
            transaction.amount.negate()
            cell.amount.text = String(transaction.amount)
            cell.amount.textColor = UIColor(red: 32/255, green: 161/255, blue: 109/255, alpha: 1)
            transaction.amount.negate()
        }
        else{
            transaction.amount.negate()
             cell.amount.text = String(transaction.amount)
             cell.amount.textColor = UIColor(red: 240/255, green: 105/255, blue: 105/255, alpha: 1)
             transaction.amount.negate()
            }
        }
        return cell
        }
}








