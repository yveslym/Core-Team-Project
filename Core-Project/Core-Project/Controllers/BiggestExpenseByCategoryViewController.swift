//
//  BiggestExpenseByCategoryViewController.swift
//  Core-Project
//
//  Created by Yveslym on 12/28/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class BiggestExpenseByCategoryViewController: UIViewController {

    // - MARK: Properties
    let stack = CoreDataStack.instance
    
    
    var transactions = [Transaction]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    // - MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BiggestExpenseByCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        
        
        
        
        return cell!
    }
    
    
}
