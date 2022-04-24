//
//  Rasterizer.swift
//  Rasterizer
//
//  Created by Eneko Alonso on 4/21/22.
//

import Foundation
import SwiftUI

public struct Rasterizer {

    public init() {}

    public func rasterize<V: View>(view: V, size: CGSize, output: URL) throws {
        let computerScale = NSScreen.main?.backingScaleFactor ?? 1
        let wrapper = NSHostingView(rootView: view)
        wrapper.frame = CGRect(
            x: 0,
            y: 0,
            width: size.width * computerScale,
            height: size.height * computerScale
        )

        guard let png = rasterize(view: wrapper, format: .png) else {
            throw "Failed to rasterize image with size \(size)"
        }
        try png.write(to: output)
    }

    func rasterize(view: NSView, format: NSBitmapImageRep.FileType) -> Data? {
        guard let bitmapRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
        bitmapRepresentation.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRepresentation)
        return bitmapRepresentation.representation(using: format, properties: [:])
    }

}

extension CGSize {
    // MARK: Predetermined Sizes

    public static let screen1080p = CGSize(width: 1920, height: 1080)
    public static let retina1080p = CGSize(width: 3840, height: 2160)
    public static let retina4k = CGSize(width: 4096, height: 2304)
    public static let retina5k = CGSize(width: 5120, height: 2880)

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

extension String: LocalizedError {
    public var errorDescription: String? {
        self
    }
}
