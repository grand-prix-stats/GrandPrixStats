//
//  SeasonRepository.swift
//  GPSModel
//
//  Created by Eneko Alonso on 6/6/22.
//

import Foundation
import MySQLKit
import Database
import GPSEntities

public final class SeasonRepository: Repository {
    /// List of seasons
    public func allSeasons() async throws -> [GPSSeason] {
        let sql: SQLQueryString = """
        select * from gpsSeasons order by year desc
        """
        return try await execute(sql)
    }

    public func currentSeason() async throws -> GPSSeason {
        let year = SeasonCalendar.currentYear
        let sql: SQLQueryString = """
        select * from gpsSeasons where year = \(bind: year)
        """
        return try await execute(sql)[0]
    }
}
