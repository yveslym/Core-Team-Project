//
//  Plaid+Extension.swift
//  Core-Project
//
//  Created by Yveslym on 12/5/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import UIKit
import LinkKit

protocol plaidDelegate: class {
    func presentPlaidLink()
}

extension plaidDelegate where Self: UIViewController {
    
   
    /// function to set-up and present Plaid UI
    func presentPlaidLink(){
        // KeyChainData.publicKey()
        let linkConfiguration = PLKConfiguration(key: KeyChainData.publicKey()!,
                                                 env: .development,
                                                 product:.connect,
                                                 selectAccount: true,
                                                 longtailAuth: false,
                                                 apiVersion: .PLKAPILatest)
        
        linkConfiguration.clientName = "Core Project"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate )
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        self.present(linkViewController, animated: true, completion: nil)
        
    }
}


extension UIViewController: PLKPlaidLinkViewDelegate{
    
    public func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: metadata!, options: .sortedKeys)
            var bank = try JSONDecoder().decode(Bank.self, from: jsonData)
           
            plaidOperation.itemAccess(publicToken: publicToken, completion: { (itemAccess) in
                
                bank.itemAccess = itemAccess
                plaidOperation.accounts(bank: bank, completion: { (accounts) in
                  
                    accounts?.forEach({ (account) in
                        account.bank = bank
                        bank.addToAccounts(account)
                        })
                    
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let endDate = Date()
                let startDate = Calendar.current.date(byAdding: .day, value: -360, to: endDate)
            
                plaidOperation.transaction(with: bank, startDate: startDate!, endDate: endDate, completion: { (allTransaction) in
                        
                        if allTransaction != nil{
                            
                        let accounts = bank.accounts?.allObjects as? [Account]
                            
                            // insert each transaction in the respective account
                            allTransaction?.forEach({ (transaction) in
                                accounts?.forEach({ (account) in
                                    if transaction.accountID == account.id{
                                        transaction.account = account
                                        account.addToTransactions(transaction)
                                    }
                                })
                            })
                            
                            // save in the core data
                             let stack = CoreDataStack.instance
                            let objectID = bank.objectID
                            let privateBank = stack.privateContext.object(with: objectID) as! Bank
                            bank = privateBank
                            stack.saveTo(context: stack.privateContext)
                            
                        }
                })
              })
            })
            self.dismiss(animated: true, completion: nil)
            self.reloadInputViews()
        }
        catch{
            print("Failure in Extension LinkBankAccountController", error)
        }
    }
    
    public func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        let alert = UIAlertController(title: "Failure",
                                      message:  "error: \(error?.localizedDescription ?? "nothing")\nmetadata: \(metadata!)",
            preferredStyle: UIAlertControllerStyle.alert)
        print("Alerts view can be ported us")
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
        if event == "EXIT"{
            self.dismiss(animated: true, completion: nil)
           
        }
    }
}



























