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
       
         self.contentView.layer.borderWidth = 5.0
        // self.backgroundColor = UIColor.white//(displayP3Red: 118/255, green: 157/255, blue: 172/255, alpha: 1)
                self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.mainView.layer.masksToBounds = true
       
        //
                self.mainView.layer.shadowColor = UIColor.lightGray.cgColor
        //        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        //        self.layer.shadowRadius = 2.0
        //        self.layer.shadowOpacity = 1.0
        //        self.layer.masksToBounds = false
                self.mainView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
