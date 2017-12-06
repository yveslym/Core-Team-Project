//
//  LinkBankAcountViewController.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import LinkKit
import KeychainSwift


/// view controller made only to call the plaid link Bank account UI
class LinkBankAcountViewController: UIViewController {
    var transactions: [Transaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presentPlaidLink()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentPlaidLink()
    }
    
    /// function to set-up and present Plaid UI
    func presentPlaidLink(){
        // KeyChainData.publicKey()
        let linkConfiguration = PLKConfiguration(key: "8bb4e37cb6ad720c4b2ab3c6107ce7",
                                                 env: .development,
                                                 product:.connect,
                                                 selectAccount: true,
                                                 longtailAuth: false,
                                                 apiVersion: .PLKAPILatest)
        
        linkConfiguration.clientName = "Core Project"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
    }
    
}

extension LinkBankAcountViewController: PLKPlaidLinkViewDelegate{
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: metadata!, options: .sortedKeys)
            var bankAccount = try JSONDecoder().decode(BankAccount.self, from: jsonData)
            // KeyChainData.clientId()
            // KeyChainData.secret()
            Networking.network(route: .exchangeToken,
                               apiHost: .development,
                               clientId: "5a0e10dfbdc6a46838fe6283",
                               secret: "a2c5ff8e5fa75701955d548d79bbe9",
                               public_token: publicToken,
                               completion: { (data) in
                
                let itemAccess = try! JSONDecoder().decode(ItemAccess.self, from: data!)
                bankAccount.itemAccess = itemAccess
                print(bankAccount)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy" // "yyyy-MM-dd"
                let date = Date()
                let yesterday = Calendar.current.date(byAdding: .day, value: -30, to: date)
                let days : [Date]? = [yesterday!,date]
                
                DispatchQueue.global().sync {
                    // KeyChainData.clientId()
                    // KeyChainData.secret()
                    Networking.network(bank: bankAccount,
                                       route: .transactions,
                                       apiHost: .development,
                                       clientId: "5a0e10dfbdc6a46838fe6283",
                                       secret: "a2c5ff8e5fa75701955d548d79bbe9",
                                       date: days,
                                       completion: { (data) in
                                        let myTransaction = try! JSONDecoder().decode(transactionOperation.self, from: data!)
//                                        print(myTransaction)
//                                        print(myTransaction.transactions.count, "COUNT-------")
                                        myTransaction.transactions.forEach({ (transaction) in
//                                            print("\n")
//                                            print("----Transaction: -----")
//                                            print(transaction)
                                            self.transactions = myTransaction.transactions
                                            self.dismiss(animated: true) {
                                                self.performSegue(withIdentifier: Identifiers.linkBankUnwindToHome, sender: self)
                                            }
                                        
                                        })
                                        
                    })
                }
            })
        }
        catch{
            print("Failure in Extension LinkBankAccountController", error)
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        let alert = UIAlertController(title: "Failure",
                                      message:  "error: \(error?.localizedDescription)\nmetadata: \(metadata!)",
            preferredStyle: UIAlertControllerStyle.alert)
        print("Alerts view can be ported us")
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}





