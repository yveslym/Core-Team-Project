//
//  calendarViewCell.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import JTAppleCalendar

class calendarViewCell: JTAppleCell {

    // - MARK: IBOutlets
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.cornerRadius = 8.0
       // self.contentView.layer.borderWidth = 5.0
       // self.backgroundColor = UIColor.white//(displayP3Red: 118/255, green: 157/255, blue: 172/255, alpha: 1)
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
//        
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
