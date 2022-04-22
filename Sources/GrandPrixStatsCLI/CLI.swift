//
//  CLI.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import Foundation
import Rasterizer
import SwiftUI
import Visualizations

@main
struct CLI {
    static func main() throws {
        print("Grand Prix Stats Command Line Tool")
        let url = URL(fileURLWithPath: "test.png")
        try Rasterizer().rasterize(view: RacePodiumsView(racePodiums: .imola), size: .retina4k, output: url)
    }
}
