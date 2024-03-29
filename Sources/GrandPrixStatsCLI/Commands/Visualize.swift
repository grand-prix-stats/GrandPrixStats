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
                DriverLapsByDuration.self,
                DriverLapsInPosition.self,
                DriverSeasonStandings.self,
                DriverStandings.self,
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
            let seasons = try await SeasonRepository().allSeasons()
                .filter { range.contains($0.year) }
                .sorted(using: KeyPathComparator(\.year))
            
            for season in seasons {
                for round in 1...season.rounds {
                    let year = season.year
                    print("Processing \(year) round \(round)")
                    let seasonURL = URL(fileURLWithPath: "visualizations/\(year)")
                    let roundPath = seasonURL.appendingPathComponent("round-\(round)")

                    try await DriverStandings.run(
                        year: year,
                        round: round,
                        size: StandingsView.defaultSize,
                        output: roundPath.appendingPathComponent("driver-standings.png")
                    )

                    try await DriverSeasonStandings.run(
                        year: year,
                        round: round,
                        size: .init(width: CGFloat(640 * round), height: StandingsView.defaultSize.height),
                        output: roundPath.appendingPathComponent("driver-season-standings.png")
                    )

                    try await DriverLapsInPosition.run(
                        year: year,
                        round: round,
                        size: LapsInPositionView.defaultSize,
                        output: roundPath.appendingPathComponent("driver-laps-in-position.png")
                    )

                    try await DriverLapsByDuration.run(
                        year: year,
                        round: round,
                        size: LapTimesByDurationView.defaultSize,
                        output: roundPath.appendingPathComponent("driver-laps-by-duration.png")
                    )

                    try await ConstructorStandings.run(
                        year: year,
                        round: round,
                        size: CGSize(width: 2100, height: 1200),
                        output: roundPath.appendingPathComponent("constructor-standings.png")
                    )

                    try await RacePodiums.run(
                        year: year,
                        round: round,
                        size: RacePodiumsView.defaultSize,
                        output: roundPath.appendingPathComponent("race-podiums.png")
                    )
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
                print("Skipping race-podium visualization for \(year) round \(round) - no data")
                return
            }
            let view = StrippedBackgroundView(padding: 50) {
                RacePodiumsView(racePodiums: rows)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }

    struct DriverStandings: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions
        @OptionGroup var raceOptions: RaceOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try await Self.run(year: raceOptions.year, round: raceOptions.round, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let rows = try await StandingsRepository().driverStandings(year: year, round: round)
            let view = StrippedBackgroundView(padding: 50) {
                StandingsView(title: "Driver Standings before and after", standings: rows)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }

    struct DriverSeasonStandings: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions
        @OptionGroup var raceOptions: RaceOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? 640 * raceOptions.round,
                height: outputOptions.height ?? Int(SeasonStandingsView.defaultSize.height)
            )
            try await Self.run(year: raceOptions.year, round: raceOptions.round, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let rows = try await StandingsRepository().driverSeasonStandings(year: year, fromRound: 1, toRound: round)
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
        @OptionGroup var raceOptions: RaceOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(StandingsView.defaultSize.width),
                height: outputOptions.height ?? Int(StandingsView.defaultSize.height)
            )
            try await Self.run(year: raceOptions.year, round: raceOptions.round, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let rows = try await StandingsRepository().constructorStandings(year: year, round: round)
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

    struct DriverLapsInPosition: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions
        @OptionGroup var raceOptions: RaceOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(LapsInPositionView.defaultSize.width),
                height: outputOptions.height ?? Int(LapsInPositionView.defaultSize.height)
            )
            try await Self.run(year: raceOptions.year, round: raceOptions.round, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let dataSet = try await LapRepository().lapsByPosition(year: year, round: round)
            let view = StrippedBackgroundView(padding: 50) {
                LapsInPositionView(year: year, dataSet: dataSet)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }

    struct DriverLapsByDuration: AsyncParsableCommand {
        @OptionGroup var outputOptions: OutputOptions
        @OptionGroup var raceOptions: RaceOptions

        func run() async throws {
            let size = CGSize(
                width: outputOptions.width ?? Int(LapTimesByDurationView.defaultSize.width),
                height: outputOptions.height ?? Int(LapTimesByDurationView.defaultSize.height)
            )
            try await Self.run(year: raceOptions.year, round: raceOptions.round, size: size, output: outputOptions.filePath)
        }

        static func run(year: Int, round: Int, size: CGSize, output: URL) async throws {
            let dataSet = try await LapRepository().lapsByDuration(year: year, round: round)
            let view = StrippedBackgroundView(padding: 50) {
                LapTimesByDurationView(year: year, dataSet: dataSet)
            }
            try await Rasterizer().rasterize(view: view, size: size, output: output)
        }
    }
}
