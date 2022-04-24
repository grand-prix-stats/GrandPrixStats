//
//  CLI.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import Database
import GPSModels
import Rasterizer
import SwiftUI
import Visualizations

@main
struct CLI {
    static func main() throws {
        print("Grand Prix Stats Command Line Tool")

        let rows = try RaceRepository().lastestPodiums(circuitRef: "albert_park")

        let view = RacePodiumsView(circuitName: "Albert Park 🇦🇺", racePodiums: rows)
            .padding(50)
            .background(Color.black)


        let url = URL(fileURLWithPath: "test.png")
        try Rasterizer().rasterize(
            view: view,
            size: RacePodiumsView.preferredSize,
            output: url
        )
    }
}
