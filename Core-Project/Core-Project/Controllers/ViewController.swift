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
     weak var delegate: plaidDelegate!
    
     var thisdate = String()
    var monthSize: MonthSize? = nil
    let numberOfRows = 5
    
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    
    var inDate = [String]()
    var outDate = [String]()
    let firstDayOfWeek: DaysOfWeek = .monday
    let monthlysummery = [String:Double]()
    
    // - MARK: IBOutlets
   
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableTack: UIStackView!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var outcome: UILabel!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var dayStackView: UIStackView!
    
    @IBOutlet weak var monthStack: UIStackView!
    
    
    @IBOutlet weak var expenseStack: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    
    var prePostVisibility: ((CellState, calendarViewCell?)->())?
    
    var transactionDetail : [Transaction]?
    
    var transactions = [Transaction]() {
        didSet {
            if transactions.count > 0 {
                shouldUpdateUI(true)
                
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
    
    // - MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.delegate = self
        tableView.dataSource = self
        delegate = self
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
    
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        self.calendarView.minimumLineSpacing = 2
        self.calendarView.minimumInteritemSpacing = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.center.y += self.view.bounds.height
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        // fetch transaction from core data
        self.transactions = {
            let record = stack.fetchRecordsForEntity(.Transaction, inManagedObjectContext: stack.viewContext)
            let trans = record as? [Transaction]
            
            return trans!
        }()
    }
   
    
    // - MARK: Methods
    func updateVisibleDay(){
        
        let visibleDates =  self.calendarView.visibleDates()
        
        self.inDate.removeAll()
        self.outDate.removeAll()
        
        visibleDates.indates.forEach { (date,indexPath) in
            self.inDate.append(self.dateFormatter(date: date))
        }
        
        visibleDates.outdates.forEach { (date,indexPath) in
            self.outDate.append(self.dateFormatter(date: date))
        }
    }
    
    func dateFormatter(date: Date) -> String{
        formatter.dateFormat = "yyyy-MM-dd"
        let day = formatter.string(from: date)
        return day
    }
    
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
        self.monthLabel.text = monthName + " " + String(year)
    }
    
    // funtion to configure cell
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? calendarViewCell  else { return }
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        //handleCellSelection(view: myCustomCell, cellState: cellState)
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        //handleCellSelection(view: cell, cellState: cellState)
        //handleCellTextColor(view: cell as? calendarViewCell, cellState: cellState)
        //prePostVisibility?(cellState, cell as? calendarViewCell)
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
        
        let parameters = ConfigurationParameters(startDate: startDate!,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek)
        return parm
    }
    
    
}
// - MARK: Calendar View Cycle

extension ViewController: JTAppleCalendarViewDelegate{
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    // function to setup the table view when a date has been seleted
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
        
        if cellState.isSelected {
            // same cell reselected and the table view is visible: make it invisible
            if thisdate == cellState.date.toString() && self.tableView.center.y < self.view.bounds.height{
                UIView.animate(withDuration: 0.5){
                    self.tableView.center.y += self.view.bounds.height
                }
            }
            else{
         thisdate = cellState.date.toString()
        self.transactionDetail = Transaction.transactionOfSameDate(date: date.toString(), transaction: self.transactions)
        
                // if no transaction and tableview visible: Make it invisible
        if self.transactionDetail?.count == 0 &&  self.tableView.center.y < self.view.bounds.height{
                UIView.animate(withDuration: 0.5){
                    self.tableView.center.y += self.view.bounds.height
                }
        }
        // if transaction and table view invisible, make it visible
        else if !((self.transactionDetail?.isEmpty)!) && self.tableView.center.y > self.view.bounds.height {
          UIView.animate(withDuration: 0.5){
            self.tableView.center.y -= self.view.bounds.height
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        }
//        let date = self.dateFormatter(date: cellState.date)
//
//
//        if self.transactionDetail?.first?.date == date{
//            self.transactionDetail = nil
//
//            DispatchQueue.main.async {
//
//                UIView.animate(withDuration: 0.9){
//                    self.tableView.center.y -= self.view.bounds.height
//                     self.tableView.reloadData()
//                }
//            }
//        }
//
//        else {
//            self.transactionDetail = [Transaction]()
//            self.transactions.forEach { (transaction) in
//                if transaction.date == date{
//                    self.transactionDetail?.append(transaction)
//                }
//            }
//            if self.transactionDetail?.count  != 0{
//
//                DispatchQueue.main.async {
//
//                    UIView.animate(withDuration: 0.9){
//                        self.tableView.center.y += self.view.bounds.height
//                         self.tableView.reloadData()
//                    }
//                }
//            }
//
//
//            else{
//                DispatchQueue.main.async {
//
//                    UIView.animate(withDuration: 0.9){
//                        self.tableView.center.y -= self.view.bounds.height
//                         self.tableView.reloadData()
//                    }
//                }
//            }
//        }
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
        
        
        formatter.dateFormat = "yyyy-MM"
        guard let date = visibleDates.monthDates.first?.date else {return}
        let day = formatter.string(from: date)
        let mytrans = self.transactions.filter({($0.date?.hasPrefix(day))!})
        print (mytrans)
        let income = mytrans.filter({$0.amount < 0})
        let outcome = mytrans.filter({$0.amount > 0})
        
        var myout : Double = 0.0
        var myin : Double = 0.0
        for trans in outcome{
            
            myout += trans.amount
        }
        for trans in income{
            trans.amount.negate()
            myin += trans.amount
            trans.amount.negate()
        }
        
        //self.income.text = String(myin)
        //self.outcome.text = String(myout)
        
    }
    
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        
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
        
        // check inDate and outDate
        self.updateVisibleDay()
        
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
        
        self.inDate.forEach { (inday) in
            if day == inday{
                cell.amount.text = ""
            }
        }
        self.outDate.forEach { (outday) in
            if day == outday{
                cell.amount.text = ""
            }
        }
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
        
        
//    let date = CellState.date
//        let trans = Transaction.transactionOfSameDate(date: CellState().date.toString, transaction: self.transactions)
        
        
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








