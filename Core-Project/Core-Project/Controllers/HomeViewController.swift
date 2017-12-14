//
//  HomeViewController.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import KeychainSwift

class HomeViewController: UIViewController, plaidDelegate {
   
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var dayStackView: UIStackView!
    
    @IBOutlet weak var monthStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var expenseStack: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        calendar.delegate = self
        setUpView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
           // self.tableViewAppear()
        }
    }
    func setUpView(){
        NSLayoutConstraint.activate([
            
            view1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            view2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.50),
            view3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
             expenseStack.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.30),
             monthStack.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.50),
            dayStackView.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.20)
           
            
            ])
    }
    
    func tableViewAppear(){
        
       // view.clearConstraints()
        NSLayoutConstraint.activate([
            
            
            view1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            view2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            view3.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            expenseStack.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.30),
            monthStack.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.50),
            dayStackView.heightAnchor.constraint(equalTo: view1.heightAnchor, multiplier: 0.20)
            
            
            ])
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
         // let calendar = Calendar.current
        
        
        return 0
    }
    
    
  

    
}
extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}





