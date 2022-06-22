//
//  Visualize.swift
//  GrandPrixStatsCLI
//
//  Created by Eneko Alonso on 5/1/22.
//

import ArgumentParser
import Database
import GPSModel
import GPSEntities
import Rasterizer
import SwiftUI
import Visualizations

extension CLI {
    struct Visualize: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "visualize",
            abstract: "Generate visualizations from Grand Prix Stats database",
            subcommands: [
                All.self,
                ConstructorStandings.self,
                DriverStandings.self,
                DriverSeasonStandings.self,
                FinishedRaces.self,
                RacePodiums.self
            ]
        )
    }
}

extension CLI.Visualize {
    struct All: AsyncParsableCommand {
        @Option(name: .shortAndLong, help: "Initial season year")
        var fromYear: Int = SeasonCalendar.currentYear
        @Option(name: .shortAndLong, help: "Final season year")
        var toYear: Int = SeasonCalendar.currentYear

        func run() async throws {
            let range = fromYear...toYear
            let seasons = try await SeasonRepository().allSeasons().filter { range.contains($0.year) }
            for season in seasons {
                for round in 1...season.rounds {
                    let year = season.year
                    print("Processing \(year) round \(round)")
                    let seasonURL = URL(fileURLWithPath: "visualizations/\(year)")
                    let roundPath = seasonURL.appendingPathComponent("round-\(round)")
                    try await DriverStandings.run(year: year, round: round, size: StandingsView.defaultSize, output: roundPath.appendingPathComponent("driver-standings.png"))
                    try await ConstructorStandings.run(year: year, round: round, size: CGSize(width: 2100, height: 1200), output: roundPath.appendingPathComponent("constructor-standings.png"))
                    try await RacePodiums.run(year: year, round: round, size: RacePodiumsView.defaultSize, output: roundPath.appendingPathComponent("race-podiums.png"))

                    try await StandingsRepository().constructorStandings()
                }
            }
        }
    }

    struct RacePodiums: AsyncParsableCommand {
        @OptionGroup var raceOptions: RaceOptions
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(RacePodiumsView.defaultSize.width),
                height: outputOptions.height ?? Int(RacePodiumsView.defaultSize.height)
            )
            try await Self.run(year: raceOptions.year, round: raceOptions.round, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let rows = try await RaceResultsRepository().lastestPodiums(year: year, round: round)
            if rows.isEmpty {
                throw "No entries for selected parameters"
            }
            let view = StrippedBackgroundView(padding: 50) {
                RacePodiumsView(racePodiums: rows)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }

    struct DriverStandings: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try await Self.run(year: 2022, round: 7, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let rows = try await StandingsRepository().driverStandings()
            let view = StrippedBackgroundView(padding: 50) {
                StandingsView(title: "Driver Standings before and after", standings: rows)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }

    struct DriverSeasonStandings: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions

        @Option(name: .shortAndLong, help: "Season year")
        var year: Int

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(SeasonStandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(SeasonStandingsView.defaultSize.height)
            )
            try await Self.run(year: year, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, size: CGSize, output: URL) async throws {
            let rows = try await StandingsRepository().driverSeasonStandings(year: year)
            let view = StrippedBackgroundView(padding: 50) {
                SeasonStandingsView(title: "Driver Standings", year: year, seasonStandings: roundStandings(with: rows))
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }

        static func roundStandings(with driverStandings: [SimpleDriverStanding]) -> [Round] {
            let dict = Dictionary(grouping: driverStandings, by: \.round)
            return dict.keys.sorted().map { round -> Round in
                let roundStandings: [SimpleDriverStanding] = dict[round] ?? []
                let standings = roundStandings.sorted { $0.position < $1.position }.map { standing in
                    DriverRoundStanding(position: standing.position, name: standing.code, points: standing.points, mainColor: standing.mainColor)
                }
                return Round(
                    round: round,
                    name: "\(roundStandings[0].raceCountry.prefix(3)) \(roundStandings[0].raceFlag)",
                    standings: standings
                )
            }
        }
    }

    struct ConstructorStandings: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try await Self.run(year: 2022, round: 7, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let rows = try await StandingsRepository().constructorStandings()
            let view = StrippedBackgroundView(padding: 50) {
                StandingsView(title: "Constructor Standings before and after", standings: rows)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }

    struct FinishedRaces: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions
        @Option(name: .shortAndLong, help: "Driver reference (identifier)")
        var driver: String

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try await Self.run(driverRef: driver, size: size, output: outputOptions.filePath)
        }

        static func run(driverRef: String, size: CGSize, output: URL) async throws {
            let rows = try await RaceResultsRepository().finishedRaces(driverRef: driverRef)
            let view = StrippedBackgroundView(padding: 50) {
                Text("\(rows.count)")
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }
}
