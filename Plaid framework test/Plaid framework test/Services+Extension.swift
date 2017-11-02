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


extension ViewController : PLKPlaidLinkViewDelegate{
    
    // Helper method to present an alert view when login success
    func handleSuccessWithToken(publicToken: String, metadata: [String : AnyObject]?) {
        //presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata)") (swift 2 method)
        
        let alert = UIAlertController(title: "Success", message: "token: \(publicToken)\nmetadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // Helper method to present an alert view when faillure to login, with apropiete message
    func handleError(error: NSError, metadata: [String : AnyObject]?) {
        //presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata)")  (swift 2 method)
        
        let alert = UIAlertController(title: "Failure", message:  "error: \(error.localizedDescription)\nmetadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
     // Helper method to present an alert view when exiting
    func handleExitWithMetadata(metadata: [String : AnyObject]?) {
        //presentAlertViewWithTitle("Exit", message: "metadata: \(metadata)") (swift 2 method)
        
        let alert = UIAlertController(title: "Exit", message:  "metadata: \(metadata!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
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
