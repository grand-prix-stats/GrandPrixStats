//
//  Font.swift
//  Visualizations
//
//  Created by Eneko Alonso on 4/24/22.
//

import SwiftUI

extension Font {
    /// https://www.dafont.com/es/conthrax.font
    static func conthrax(_ size: CGFloat) -> Font {
        .custom("Conthrax", size: size)
    }
    /// https://www.dafont.com/es/good-timing.font
    static func goodTiming(_ size: CGFloat) -> Font {
        .custom("Good Timing", size: size)
    }
    /// https://www.dafont.com/es/terminator.font
    static func terminator(_ size: CGFloat) -> Font {
        .custom("Terminator", size: size)
    }
}
