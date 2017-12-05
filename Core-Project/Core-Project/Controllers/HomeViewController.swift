//
//  HomeViewController.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var transactions = [Transaction]() {
        didSet {
            if transactions.count > 0 {
                shouldUpdateUI(true)
                currentMonthCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var currentMonthCollectionView: UICollectionView!
    
    @IBAction func addBankAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.homeToAddBank, sender: nil)
    }
    
    @IBAction func unwindFromLinkBankAccount(_ sender: UIStoryboardSegue) {
        if sender.source is LinkBankAcountViewController {
            if let linkBankAcountViewController = sender.source as? LinkBankAcountViewController,
                let newTransactions = linkBankAcountViewController.transactions {
                
                transactions.append(contentsOf: newTransactions)
                print("shouldUpdateUI(Bool) about to be called")
                shouldUpdateUI(true)
                print("Did call shouldUpdateUI(bool)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonthCollectionView.delegate = self
        currentMonthCollectionView.dataSource = self
        shouldUpdateUI(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        print("HOMEVIEW TANSCOUNT------------------------========================------------------------")
        print(transactions.count)
    }
    
    func shouldUpdateUI(_ bool: Bool) {
        if bool {
            self.currentMonthCollectionView.isHidden = false
            self.currentMonthCollectionView.reloadData()
        } else {
            self.currentMonthCollectionView.isHidden = true
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let date = transactions[index].date
        let expense = transactions[index].amount ?? 999
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.currentMonthCell, for: indexPath) as! DailyExpenseCell
        cell.dateLabel.text = date ?? "No date"
        cell.expenseLabel.text = String(describing: expense)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("* Selected item at Row * ", indexPath.row)
    }
}
