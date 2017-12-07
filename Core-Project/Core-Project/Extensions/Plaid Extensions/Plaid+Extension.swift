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
        let linkConfiguration = PLKConfiguration(key: KeyChainData.publicKey(),
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
            var bankAccount = try JSONDecoder().decode(BankAccount.self, from: jsonData)
            
            
            
            // get item access
            
            // KeyChainData.clientId()
            // KeyChainData.secret()
            
            Networking.network(route: .exchangeToken,
                               apiHost: .development,
                               clientId: KeyChainData.clientId(),
                               secret: KeyChainData.secret(),
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
                                
                                // get transaction
                                DispatchQueue.global().sync {
                                    Networking.network(bank: bankAccount,
                                                       route: .transactions,
                                                       apiHost: .development,
                                                       clientId: KeyChainData.clientId(),
                                                       secret: KeyChainData.secret(),
                                                       date: days,
                                                       completion: { (data) in
                                                        let myTransaction = try! JSONDecoder().decode(transactionOperation.self, from: data!)
                                                        print(myTransaction)
                                                        
                                                        // link transaction to his bank
                                                        bankAccount.transactions = myTransaction.transactions
                                                        
                                                        // save the bank account
                                                        BankOperation.save(bankAccount: bankAccount)
                                                    self.dismiss(animated: true, completion: nil)
                                                         self.reloadInputViews()
                                    })
                        }
            
            })
            
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
}


