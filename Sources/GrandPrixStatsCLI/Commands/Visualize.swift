//
//  Visualize.swift
//  GrandPrixStatsCLI
//
//  Created by Eneko Alonso on 5/1/22.
//

import ArgumentParser
import Database
import GPSModels
import Rasterizer
import SwiftUI
import Visualizations

extension CLI {
    struct Visualize: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "visualize",
            abstract: "Generate visualizations from Grand Prix Stats database",
            subcommands: [
                ConstructorStandings.self,
                DriverStandings.self,
                FinishedRaces.self,
                RacePodiums.self
            ]
        )
    }
}

extension CLI.Visualize {
    struct RacePodiums: AsyncParsableCommand {
        @OptionGroup var raceOptions: RaceOptions
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let rows = try await RaceResultsRepository().lastestPodiums(year: raceOptions.year, round: raceOptions.round)
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
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let rows = try await StandingsRepository().driverStandings()
            let view = StrippedBackgroundView(padding: 50) {
                StandingsView(title: "Driver Standings before and after", standings: rows)
            }
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try Rasterizer().rasterize(view: view, size: size, output: outputOptions.filePath)
        }
    }

    struct ConstructorStandings: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let rows = try await StandingsRepository().constructorStandings()
            let view = StrippedBackgroundView(padding: 50) {
                StandingsView(title: "Constructor Standings before and after", standings: rows)
            }
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try Rasterizer().rasterize(view: view, size: size, output: outputOptions.filePath)
        }
    }

    struct FinishedRaces: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions
        @Option(name: .shortAndLong, help: "Driver reference (identifier)")
        var driver: String

        func run() async throws {
            let rows = try await RaceResultsRepository().finishedRaces(driverRef: driver)
            let view = StrippedBackgroundView(padding: 50) {
                Text("\(rows.count)")
            }
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try Rasterizer().rasterize(view: view, size: size, output: outputOptions.filePath)
        }

    }
}
