//
//  LinkBankAcountViewController.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import LinkKit


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
        
        let linkConfiguration = PLKConfiguration(key: "a26bacd40a288d215735a0cfcb1508", env: .development, product: .connect, selectAccount: true, longtailAuth: false, apiVersion: .PLKAPILatest)
        
        
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
            bankAccount.access_token = publicToken
            
            print(bankAccount)
            
            Networking.network(route: .exchangeToken, apiHost: .development, clientId: "59f67b2ebdc6a40e54b2fffc", secret: "adaaa3eaf89ada326158673d2595b2", public_token:publicToken, completion: { (data) in
                let jsondata = try! JSONSerialization.jsonObject(with: data!) as? [String: Any]
                print(jsondata)
                
                Networking.network(bank: bankAccount, route: .auth, apiHost: .sandbox, clientId: "59f67b2ebdc6a40e54b2fffc", secret: "adaaa3eaf89ada326158673d2595b2", completion: { (data) in
                    do{
                        let json = try! JSONSerialization.jsonObject(with: data!) as? [String: Any]
                        print(json!)
                        print("something")
                    }catch{}
                    
                })
                
                DispatchQueue.main.sync {
                    self.performSegue(withIdentifier: "home", sender: self)
                }
            })
        }
        catch{}
        
        //        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! HomeViewController
        //        present(homeVC, animated: true, completion: nil)
        //
        
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        
        
        let alert = UIAlertController(title: "Failure", message:  "error: \(error!.localizedDescription)\nmetadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}






