//
//  Database.swift
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
    struct Database: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "db",
            abstract: "Set up Grand Prix Stats database",
            subcommands: [
                Reset.self
            ]
        )
    }
}

extension CLI.Database {
    struct Reset: AsyncParsableCommand {
        @Option(name: .shortAndLong, help: "File path for database. WARNING: all data will be lost.")
        var path = "grandprixstats.sqlite"

        func run() async throws {
            let url = URL(fileURLWithPath: path)
            let db = try SQLite(path: url.path)
            try await db.pool.write { db in
                try? db.drop(table: TrackStatus.tableName)
                try db.create(table: TrackStatus.tableName) { table in
                    table.autoIncrementedPrimaryKey("id").notNull()
                    table.column("year", .integer).notNull()
                    table.column("round", .integer).notNull()
                    table.column("timestamp", .datetime).notNull()
                    table.uniqueKey(["year", "round", "timestamp"])
                }

                try TrackStatus(year: 2022, round: 10, timestamp: Date()).insert(db)
            }
        }
    }
}

struct TrackStatus: Codable {
    let year: Int
    let round: Int
    let timestamp: Date
}

extension TrackStatus: FetchableRecord, PersistableRecord {
    public static let tableName = "trackStatus"
}
