//
//  ExpensesCollectionViewCell.swift
//  Core-Project
//
//  Created by Yveslym on 12/16/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class ExpensesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var mainStack: UIStackView!
   
    @IBOutlet weak var summaryStack: UIStackView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var expenses: UILabel!
    @IBOutlet weak var incomes: UILabel!
    
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var month: UILabel!
    weak var delegate: delegateChart!
    
    func configureCollectionView(){
         self.view2.layer.cornerRadius = 15.0
        self.chartView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
        self.view2.layer.masksToBounds = true
        self.mainStack.distribution = .fill
        NSLayoutConstraint.activate([
           
           self.summaryStack.heightAnchor.constraint(equalTo: self.mainStack.heightAnchor, multiplier: 0.30),
           self.chartView.heightAnchor.constraint(equalTo: self.mainStack.heightAnchor, multiplier: 0.60)
            ])
    }
    
}
