//
//  Load.swift
//
//
//  Created by Eneko on 7/10/22.
//

import ArgumentParser
import Database
import GRDB
import GPSEntities
import Foundation

extension CLI {
    struct Load: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "load",
            abstract: "Load database with F1 data from remote APIs",
            subcommands: [
                Race.self
            ]
        )
    }
}

extension CLI.Load {
    struct Race: AsyncParsableCommand {
        @OptionGroup var raceOptions: RaceOptions

        func run() async throws {
            try await Self.loadRace(year: raceOptions.year, round: raceOptions.round)
        }

        static func loadRace(year: Int, round: Int) async throws {
            let url = URL(string: "https://livetiming.formula1.com/static/2018/2018-06-10_Canadian_Grand_Prix/2018-06-10_Race/TrackStatus.jsonStream")!
            let (data, response) = try await URLSession.shared.data(from: url)
            print(String(data: data, encoding: .utf8)!)
        }
    }
}
