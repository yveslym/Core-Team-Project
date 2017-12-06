//
//  DailyExpenseCell.swift
//  Core-Project
//
//  Created by Erik Perez on 12/4/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class DailyExpenseCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = .red
        self.layer.cornerRadius = 8
    }
}
