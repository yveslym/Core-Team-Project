//
//  BankCellTableViewCell.swift
//  Core-Project
//
//  Created by Yveslym on 12/11/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class BankCellTableViewCell: UITableViewCell {

    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    
    @IBOutlet weak var subtype: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
