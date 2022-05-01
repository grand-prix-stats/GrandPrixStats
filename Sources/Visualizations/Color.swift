//
//  Color.swift
//  Visualizatons
//
//  Created by Eneko Alonso on 4/23/22.
//

import SwiftUI

extension Color {
    init(hex: UInt64) {
        let red   = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >>  8) / 255.0
        let blue  = Double((hex & 0x0000FF)      ) / 255.0
        self.init(red: red, green: green, blue: blue)
    }

    init(cssColor: String) {
        let scanner = Scanner(string: cssColor.replacingOccurrences(of: "#", with: ""))
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        self.init(hex: hexNumber)
    }

    var brightnessLevel: CGFloat {
        let components = cgColor?.components?.prefix(3) ?? [0, 0, 0]
        return components.reduce(0, +) / Double(max(components.count, 1))
    }
}

extension String {
    var color: Color {
        Color(cssColor: self)
    }
}
