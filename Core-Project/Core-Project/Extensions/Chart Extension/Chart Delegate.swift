//
//  Chart Delegate.swift
//  Core-Project
//
//  Created by Yveslym on 12/15/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import SwiftCharts
import UIKit

protocol delegateChart: class {
    func chartConfiguration(month:String, cell: ChartTableViewCell, transaction:[Transaction])
}

extension delegateChart where Self: ChartTableViewCell{
    
 func chartConfiguration(month:String, cell: ChartTableViewCell, transaction:[Transaction]){
        
        let dayOfWeek = Calendar.allDayOfWeek()
        var expChart = [(String,Double)]()
        
        dayOfWeek.forEach {
            let totalExpense = Transaction.totalIncomeBydayOfWeek(dayKey: $0, monthKey: month, transaction: transaction)
            expChart.append(($0, totalExpense))
        }
        
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 10, by: 5000)
        )
        
        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
        
        let chart = BarsChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            bars: expChart,
            color: UIColor.red,
            barWidth: 20
        )
    self.chartView.addSubview(chart.view)
    }
    
}
