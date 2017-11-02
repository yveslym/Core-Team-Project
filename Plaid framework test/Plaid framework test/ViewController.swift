//
//  ViewController.swift
//  Plaid framework test
//
//  Created by Yveslym on 11/1/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import LinkKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        let linkConfiguration = PLKConfiguration(key: "a26bacd40a288d215735a0cfcb1508", env: .sandbox, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
        }

    }



