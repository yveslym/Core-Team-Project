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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // - MARK: Properties
    var allAccount = [Account]()
    let stack = CoreDataStack.instance
    let context = CoreDataStack.instance.viewContext
    weak var delegate : plaidDelegate!
    var indexPaths = [IndexPath]()
    
    var banks = [Bank](){
        didSet{
            banks.forEach {(bank) in
                let accounts = bank.accounts?.allObjects as? [Account]
                accounts?.forEach({ (account) in
                    self.allAccount.append(account)
                })
            }
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
        collectionView.delegate = self
        collectionView.dataSource = self
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

extension MyBankViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allAccount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MybankCollectionViewCell
        self.indexPaths.append(indexPath)
       
//        if indexPath.row > 0{
//        let previouscell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: self.indexPaths[indexPath.row - 1]) as! MybankCollectionViewCell
//        cell.center.y = previouscell.bounds.height - 10
//        cell.layer.borderWidth = 5
//            cell.layer.borderColor = UIColor.white.cgColor
//        }
        
        let account = self.allAccount[indexPath.row]
        cell.accountName.text = account.name
        cell.amount.text = String(account.availableBalance)
        cell.bankName.text = account.bank?.institutionName
        cell.accountNumber.text = "XXXXX\(account.accNumber)"
        return cell
    }
}





















