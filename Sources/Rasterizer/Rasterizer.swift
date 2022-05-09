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
        let computerScale = 1.0//NSScreen.main?.backingScaleFactor ?? 1
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

extension String: LocalizedError {
    public var errorDescription: String? {
        self
    }
}
