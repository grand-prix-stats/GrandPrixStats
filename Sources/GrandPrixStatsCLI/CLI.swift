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

        let rows = try RaceRepository().lastestPodiums(year: 2022, round: 4)

        let view = RacePodiumsView(racePodiums: rows)
            .padding(40)
            .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))


        let url = URL(fileURLWithPath: "test.png")
        try Rasterizer().rasterize(
            view: view,
            size: RacePodiumsView.preferredSize,
            output: url
        )
    }
}
