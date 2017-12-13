//
//  ChartTableViewCell.swift
//  Core-Project
//
//  Created by Yveslym on 12/15/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit
import SwiftCharts

class ChartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var expenses: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var summary: UILabel!
    weak var delegate: delegateChart!
    @IBOutlet weak var chartStack: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}













