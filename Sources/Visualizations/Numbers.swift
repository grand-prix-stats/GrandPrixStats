//
//  Numbers.swift
//  Visualizations
//
//  Created by Eneko Alonso on 5/1/22.
//

import Foundation

extension Double {
    var formattedPoints: String {
        if self == self.rounded() {
            return Int(self).description
        }
        return String(format: "%.1f", self)
    }
}

extension Int {
    var ordinal: String {
        return "\(self)\(ordinalSuffix)"
    }

    var ordinalSuffix: String {
        if (11...13).contains(self % 100) {
            return "th"
        }
        switch self % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}
