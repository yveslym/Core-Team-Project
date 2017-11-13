//
//  ViewController.swift
//  Plaid framework test
//
//  Created by Yveslym on 11/1/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import LinkKit


class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func LinkButtonPressed(_ sender: Any){
        self.presentPlaidLink()
        print("pressed")
    }
    func presentPlaidLink(){
        
        let conf = PLKConfiguration(key: "a26bacd40a288d215735a0cfcb1508", env: .development, product: .auth, selectAccount: true, longtailAuth: false, apiVersion: .PLKAPILatest)
        
        
        //linkConfiguration.clientName = "Link Demo"
        conf.clientName = "Yveslym App Bitch"
        
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: conf, delegate: linkViewDelegate)
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
            
        }
        present(linkViewController, animated: true)
    }
    
    // Handle success, e.g. by storing publicToken with your service
    
}

struct Model: Codable{
    var status: String
}


