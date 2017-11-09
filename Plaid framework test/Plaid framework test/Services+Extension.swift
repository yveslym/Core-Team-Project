//
//  Services+Extension.swift
//  Plaid framework test
//
//  Created by Yveslym on 11/1/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
import UIKit
import Foundation
import LinkKit


extension LoginViewController : PLKPlaidLinkViewDelegate{
    
    
    
    
    func handleSuccessWithToken(publicToken: String, metadata: [String : AnyObject]?) {
        
        let alert = UIAlertController(title: "Success", message: "token: \(publicToken)\nmetadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: metadata!, options: .sortedKeys)
            let model = try JSONDecoder().decode(Model.self, from: jsonData)
            print(model.status)
        }
        catch{}
        
//        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
//        self.present(homeVC, animated: true, completion: nil)
    }
    // Helper method to present an alert view when faillure to login, with apropiete message
    func handleError(error: NSError, metadata: [String : AnyObject]?) {
        
        let alert = UIAlertController(title: "Failure", message:  "error: \(error.localizedDescription)\nmetadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
     // Helper method to present an alert view when exiting
    func handleExitWithMetadata(metadata: [String : AnyObject]?) {
        
        let alert = UIAlertController(title: "Exit", message:  "metadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //==> Mark This function was modify by Yves to return the success status when login
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
            self.handleSuccessWithToken(publicToken: publicToken, metadata: metadata! as [String : AnyObject])
           
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                self.handleError(error: error as NSError, metadata: (metadata! as [String : AnyObject]))
                
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                self.handleExitWithMetadata(metadata: metadata! as [String : AnyObject])
            }
        }
    }
    
    
}
















// 1 -1 :single call
//       Single house - single adress
//       monogamy
//       username - password

// 1 - many     restaurant- menu
//              fruit and tree

// many - many: student - teacher
//              friendship



