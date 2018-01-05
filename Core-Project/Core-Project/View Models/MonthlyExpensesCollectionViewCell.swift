//
//  MonthlyExpensesCollectionViewCell.swift
//  Core-Project
//
//  Created by Yveslym on 12/26/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class MonthlyExpensesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var expense: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var category: UILabel!
     @IBOutlet weak var category2: UILabel!
     @IBOutlet weak var category3: UILabel!
    @IBOutlet weak var mostExpense: UILabel!
    @IBOutlet weak var mostExpense2: UILabel!
    @IBOutlet weak var mostExpense3: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 15.0
        //self.mainView.layer.masksToBounds = true
       
        self.mainView.layer.shadowColor = UIColor.lightGray.cgColor
        self.mainView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.mainView.layer.shadowRadius = 5
        self.mainView.layer.shadowOpacity = 1.5
        self.mainView.layer.masksToBounds = false
        self.mainView.layer.shadowPath = UIBezierPath(roundedRect: self.mainView.bounds, cornerRadius: self.mainView.layer.cornerRadius).cgPath

    }
}
