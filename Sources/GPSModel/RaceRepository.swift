//
//  RaceReposirory.swift
//  GPSModel
//
//  Created by Eneko on 6/25/22.
//

import Foundation
import GPSEntities
import MySQLKit

public final class RaceRepository: Repository {
    /// Returns the last completed race, might be from last season if current season has not yet started.
    public func lastRace() async throws -> GPSRace {
        let sql: SQLQueryString = """
        select * from gpsRaces where winningDriverId is not null order by raceRef desc limit 0,1
        """
        return try await execute(sql)[0]
    }

    /// Returns the next race in the calendar. Can be null if the season has ended and next season has not been
    /// added yet to the database.
    public func nextRace() async throws -> GPSRace? {
        let sql: SQLQueryString = """
        select * from gpsRaces where winningDriverId is null order by raceRef limit 0,1
        """
        return try await execute(sql).first
    }
}
