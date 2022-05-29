//
//  List.swift
//  GrandPrixStatsCLI
//
//  Created by Eneko Alonso on 5/1/22.
//

import ArgumentParser
import Database
import GPSModels

extension CLI {
    struct List: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "list",
            abstract: "List data from Grand Prix Stats database",
            subcommands: [
                Drivers.self
            ]
        )
    }
}

extension CLI.List {
    struct Drivers: AsyncParsableCommand {
        @Option(name: .shortAndLong, help: "Season year", completion: CompletionKind.list(SeasonCalendar.seasons.map(String.init)))
        var year: Int?

        func run() async throws {
            if let year = year {
                let rows = try await DriverRepository().drivers(byYear: year)
                for row in rows {
                    print(try row.decode(column: "surname", as: String.self))
                }
            }
        }
   }
}
