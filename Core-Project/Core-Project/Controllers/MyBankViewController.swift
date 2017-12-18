//
//  MyBankViewController.swift
//  Core-Project
//
//  Created by Yveslym on 12/11/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class MyBankViewController: UIViewController, plaidDelegate {

    // - MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    // - MARK: Properties
    var allAccount = [Account]()
    let stack = CoreDataStack.instance
    let context = CoreDataStack.instance.viewContext
    weak var delegate : plaidDelegate!
    
    var banks = [Bank](){
        didSet{
            banks.forEach {(bank) in
                let accounts = bank.accounts?.allObjects as? [Account]
                accounts?.forEach({ (account) in
                    self.allAccount.append(account)
                })
            }
            DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
           
        }
    }
    
    // - MARK: IBActions
    
    @IBAction func addNewBank(_ sender: Any){
        self.delegate.presentPlaidLink()
    }
    
    
    // - MARK: Table View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchAllAccount()
    }
    
    override func reloadInputViews() {
        self.fetchAllAccount()
    }
    
    func fetchAllAccount(){
         self.allAccount = []
        self.banks = {
            let record = stack.fetchRecordsForEntity(.Bank, inManagedObjectContext: stack.viewContext)
            let bank = record as? [Bank]
            return bank!
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MyBankViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! BankCellTableViewCell
        let account = self.allAccount[indexPath.row]
        cell.balance.text = String(describing: account.availableBalance)
        cell.officialName.text = account.name
        cell.cardName.text = account.officialName
        cell.cardNumber.text = "XXXXX\(account.accNumber)"
        cell.subtype.text = "available"
        return cell
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            
            let alert = UIAlertController(title: "Delete Account", message: "Do you want to delete this acount?, you will have to had it back to see the transaction again", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                
                let accountID = self.allAccount[indexPath.row].objectID
                let account = self.stack.privateContext.object(with: accountID) as! Account
                
                self.stack.delete(context: self.stack.viewContext, item: account)
                
                self.fetchAllAccount()
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
           
            
            
        }
        deleteAction.backgroundColor = UIColor.init(red: 232/255, green: 49/255, blue: 90/255, alpha: 1)
        
    return[deleteAction]
    }
    
    
}



















