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
            let bank = try JSONDecoder().decode(Bank.self, from: jsonData)
           
            plaidOperation.itemAccess(publicToken: publicToken, completion: { (itemAccess) in
             
                //bank.itemAccess = ItemAccess
                bank.itemAccess = itemAccess
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let date = Date()
                let yesterday = Calendar.current.date(byAdding: .day, value: -30, to: date)
            
                
                //DispatchQueue.global().sync {
                    plaidOperation.transaction(with: bank, startDate: yesterday!, endDate: date, completion: { (allTransaction) in
                        
                        if allTransaction != nil{
                        let accounts = bank.accounts?.allObjects as? [Account]
                        
                        for account in accounts!{
                            if account.id == allTransaction?.first?.accountID{
                                account.addToTransactions(NSSet(array: allTransaction!))
                            }
                        }
                            self.dismiss(animated: true, completion: nil)
                            self.reloadInputViews()
                        }
                        self.dismiss(animated: true, completion: nil)
                    })
                //}
                
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


