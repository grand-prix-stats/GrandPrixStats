//
//  CLI.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import ArgumentParser
import Database
import GPSModels
import Rasterizer
import Stripes
import SwiftUI
import Visualizations

@main
struct CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "gps",
        abstract: "Grand Prix Stats Command Line Tool",
        version: "1.0.0",
        subcommands: [
            Visualize.self
        ]
    )
}

extension CLI {
    struct Visualize: ParsableCommand {
        static let defaultSize = CGSize.iphone13Max

        @Option(name: .shortAndLong, help: "Season year")
        var year: Int
        @Option(name: .shortAndLong, help: "Season round")
        var round: Int
        @Option(name: .shortAndLong, help: "Output image width")
        var width = Int(defaultSize.width)
        @Option(name: .shortAndLong, help: "Output image height")
        var height = Int(defaultSize.height)
        @Option(name: .shortAndLong, help: "Output file path")
        var filePath = URL(fileURLWithPath: "test.png")

        func run() throws {
            let rows = try RaceRepository().lastestPodiums(year: year, round: round)
            if rows.isEmpty {
                throw "No entries for selected parameters"
            }

            let view = ZStack {
                Stripes(config: StripesConfig(
                    background: Color.black,
                    foreground: Color.white,
                    degrees: 30,
                    barWidth: 2,
                    barSpacing: 10
                )).opacity(0.05)

                RacePodiumsView(racePodiums: rows)
                    .padding(50)
            }
                .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))

            try Rasterizer().rasterize(
                view: view,
                size: CGSize(width: width, height: height),
                output: filePath
            )
        }
    }
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
    
}
