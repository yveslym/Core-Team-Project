//
//  TBiggestExpenseByMonthableViewCell.swift
//  Core-Project
//
//  Created by Yveslym on 12/28/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class TBiggestExpenseByMonthableViewCell: UITableViewCell {

    @IBOutlet weak var categoryInitial: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var expense: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.view1.layer.masksToBounds = true
        self.view1.layer.borderWidth = 3.0
        //self.view1.layer.borderColor?.alpha
        self.view1.layer.borderColor = UIColor().randomColor().cgColor
        self.view1.layer.cornerRadius = self.view1.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
