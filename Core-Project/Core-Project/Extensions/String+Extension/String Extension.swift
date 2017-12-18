//
//  String Extension.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
        func toDate() -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let date = formatter.date(from: self) else {return nil}
            return date
        }
    }

