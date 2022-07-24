//
//  Load.swift
//
//
//  Created by Eneko on 7/10/22.
//

import ArgumentParser
import Database
import Foundation
import F1LiveTiming
import GPSEntities
import GRDB

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
            let calendar = try RaceCalendar.load()
            guard let race = calendar.race(year: year, round: round) else {
                print("Cannot find a race with those parameters")
                throw ExitCode.failure
            }

            let url = APIEndpoint.url(race: race, session: RaceSession.driverList)
            let events = try await DataLoader.loadJSONStream(url: url)
            let drivers = events.compactMap { event in
                try? f1LiveTimingJSONDecoder.decode([String: Driver].self, from: event.event)
            }
            print(drivers.first!.values.sorted(using: KeyPathComparator(\.racingNumber)))
        }
    }
}
