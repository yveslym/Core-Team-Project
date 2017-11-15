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
class LinkBankAcountViewController: UIViewController, PLKPlaidLinkViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.presentPlaidLink()
    }
    
    /// function to set-up and present Plaid UI
    func presentPlaidLink(){
        
        let linkConfiguration = PLKConfiguration(key: KeyChainData.publicKey(), env: .development, product:.connect, selectAccount: true, longtailAuth: false, apiVersion: .PLKAPILatest)
        
        
        linkConfiguration.clientName = "Core Project"
        
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
    }
    
}

extension LinkBankAcountViewController{
    

    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: metadata!, options: .sortedKeys)
            var bankAccount = try JSONDecoder().decode(BankAccount.self, from: jsonData)
            
            Networking.network(route: .exchangeToken, apiHost: .development, clientId: KeyChainData.clientId(), secret: KeyChainData.secret(), public_token:publicToken, completion: { (data) in
                
                let itemAccess = try! JSONDecoder().decode(ItemAccess.self, from: data!)
                bankAccount.itemAccess = itemAccess
                print(bankAccount)
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let date = Date()
                let yesterday = Calendar.current.date(byAdding: .day, value: -30, to: date)
                
                let day1 = formatter.string(from: date)
                let day2 = formatter.string(from: yesterday!)
                let days : [String]? = [day2,day1]
                
                DispatchQueue.global().sync {
                    Networking.network(bank: bankAccount, route: .transactions, apiHost: .development, clientId: KeyChainData.clientId(), secret: KeyChainData.secret(), date: days, completion: { (date) in
                        let jsondata = try! JSONSerialization.jsonObject(with: data!)
                        print(jsondata)
                    })
                }
            })
        }
catch{}
}
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        
        let alert = UIAlertController(title: "Failure", message:  "error: \(error!.localizedDescription)\nmetadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}






