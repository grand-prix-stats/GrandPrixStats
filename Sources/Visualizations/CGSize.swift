//
//  CGSize.swift
//  Visualizations
//
//  Created by Eneko Alonso on 4/24/22.
//

import Foundation

extension CGSize {

    // MARK: 16:9

    public static let screen1080p = CGSize(width: 1920, height: 1080)
    public static let screen4K = CGSize(width: 3840, height: 2160)
    public static let retina4k = CGSize(width: 4096, height: 2304)
    public static let screen5K = CGSize(width: 5120, height: 2880)
    public static let screen6K = CGSize(width: 6016, height: 3384)
    public static let iphone13Max = CGSize(width: 1284, height: 2778)

    public static func square(side: CGFloat) -> CGSize {
        .init(width: side, height: side)
    }

    public var inverted: CGSize {
        .init(width: height, height: width)
    }

    public func scaled(by multiplier: CGFloat) -> CGSize {
        .init(width: width * multiplier, height: height * multiplier)
    }
}
