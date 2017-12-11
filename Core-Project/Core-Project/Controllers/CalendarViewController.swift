//
//  CalendarViewController.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, plaidDelegate,JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
   
    

    // - MARK: IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    // - MARK: Properties
    
    let stack = CoreDataStack.instance
    let formatter = DateFormatter()
    weak var delegate: plaidDelegate?
    
    var transactions = [Transaction]() {
        didSet {
            if transactions.count > 0 {
                shouldUpdateUI(true)
                calendarView.reloadData()
                
                let histo = sortTransactions(transactions: transactions)
                
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
                DispatchQueue.main.async {
                    self.calendarView.reloadData()

                }
            }
        }
    }
    
    var dayExpenses = [DayExpense]() //{
//        didSet{
//           // dayExpenses.sort { $0.date < $1.date }
//            //DispatchQueue.main.async {
//                self.calendarView.reloadData()
//            //}
//
//        }
//    }
    
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
        //handleCellSelection(view: myCustomCell, cellState: cellState)
    }
    func handleCellTextColor(view: calendarViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            view.day.textColor = UIColor.black
        } else {
            view.day.textColor = UIColor.gray
        }
    }
    
    
    var iii: Date?


    @IBAction func addBankAccountButtonPressed(_ sender: UIButton) {
        
        delegate?.presentPlaidLink()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        calendarView.calendarDelegate = self
//        calendarView.calendarDataSource = self
        delegate = self
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
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
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as! calendarViewCell
        
//        configureCell(view: cell, cellState: cellState)
//         cell.day.text = cellState.text
//        if cellState.text == "1" {
//            formatter.dateFormat = "MMM"
//            let month = formatter.string(from: date)
//            cell.day.text = "\(month) \(cellState.text)"
//        } else {
//            cell.day.text = cellState.text
//        }
//
//        for dayExp in self.dayExpenses {
//            if dayExp.date == formatter.string(from: cellState.date){
//                cell.amount.text = String(dayExp.totalAmount)
//                break
//            }
        //}
        cell.day.text = cellState.text
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        //self.configureCell(view: cell, cellState: cellState)

    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        setupViewsOfCalendar(from: visibleDates)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        configureCell(view: cell, cellState: cellState)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        configureCell(view: cell, cellState: cellState)
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        calendarView.viewWillTransition(to: size, with: coordinator, anchorDate: iii)
//    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        formatter.dateFormat = "dd-MM-yyyy"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//        let endDate = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -360, to: endDate)
//        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate)
//
//        return parameters

        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -360, to: endDate)
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate)
        
        return parameters
       
       
    }


//extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate{
//    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as! calendarViewCell
//
//        configureCell(view: cell, cellState: cellState)
//        if cellState.text == "1" {
//            formatter.dateFormat = "MMM"
//            let month = formatter.string(from: date)
//            cell.day.text = "\(month) \(cellState.text)"
//        } else {
//            cell.day.text = cellState.text
//        }
//
//        for dayExp in self.dayExpenses {
//            if dayExp.date == formatter.string(from: cellState.date){
//                cell.amount.text = String(dayExp.totalAmount)
//                break
//            }
//        }
//         return cell
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//        self.configureCell(view: cell, cellState: cellState)
//
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        setupViewsOfCalendar(from: visibleDates)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        configureCell(view: cell, cellState: cellState)
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        configureCell(view: cell, cellState: cellState)
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        calendarView.viewWillTransition(to: size, with: coordinator, anchorDate: iii)
//    }
//
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        formatter.dateFormat = "yyy MM dd"//"dd-MM-yyyy"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//        let endDate = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -360, to: endDate)
//        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate)
//
//        return parameters
//        }
//    }
//
}
