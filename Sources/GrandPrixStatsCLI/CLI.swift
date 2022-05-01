//
//  CLI.swift
//  GrandPrixStatsCLI
//
//  Created by Eneko Alonso on 4/21/22.
//

import ArgumentParser
import Database
import GPSModels
import Rasterizer
import SwiftUI
import Visualizations

@main
struct CLI: AsyncParsableCommand {
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
    struct Visualize: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "visualize",
            abstract: "Generate visualizations from Grand Prix Stats database",
            subcommands: [
                DriverStandings.self,
                RacePodiums.self
            ]
        )
    }
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}

struct OutputOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output image width")
    var width: Int?
    @Option(name: .shortAndLong, help: "Output image height")
    var height: Int?
    @Option(name: .shortAndLong, help: "Output file path")
    var filePath = URL(fileURLWithPath: "test.png")
}

struct RaceOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Season year")
    var year: Int
    @Option(name: .shortAndLong, help: "Season round")
    var round: Int
}

extension CLI.Visualize {
    struct RacePodiums: AsyncParsableCommand {
        @OptionGroup var raceOptions: RaceOptions
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let rows = try await RaceRepository().lastestPodiums(year: raceOptions.year, round: raceOptions.round)
            if rows.isEmpty {
                throw "No entries for selected parameters"
            }
            let view = StrippedBackgroundView(padding: 50) {
                RacePodiumsView(racePodiums: rows)
            }
            let size = CGSize(
                width: outputOptions.width ?? Int(RacePodiumsView.defaultSize.width),
                height: outputOptions.height ?? Int(RacePodiumsView.defaultSize.height)
            )
            try Rasterizer().rasterize(view: view, size: size, output: outputOptions.filePath)
        }
    }

    struct DriverStandings: AsyncParsableCommand {
//        @OptionGroup var raceOptions: RaceOptions
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let rows = try await StandingsRepository().driverStandings()
            if rows.isEmpty {
                return
            }
            let view = StrippedBackgroundView(padding: 50) {
//                RacePodiumsView(racePodiums: rows)
            }
            let size = CGSize(
                width: outputOptions.width ?? Int(RacePodiumsView.defaultSize.width),
                height: outputOptions.height ?? Int(RacePodiumsView.defaultSize.height)
            )
            try Rasterizer().rasterize(view: view, size: size, output: outputOptions.filePath)
        }
    }
}
