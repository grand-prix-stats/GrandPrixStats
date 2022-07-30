//
//  DriverRepository.swift
//  GPSModel
//
//  Created by Eneko Alonso on 5/1/22.
//

import Foundation
import GPSEntities
import SQLKit

public class DriverRepository: Repository {

    public func drivers(byYear year: Int) async throws -> [SQLRow] {
        let sql: SQLQueryString = """
        select *
          from gpsDrivers
         where driverRef in (select driverRef from gpsDriverStandings where year = \(bind: year))
        """
        return try await execute(sql)
    }

    /// Races finished by driver
    /// - Parameter driverRef: driver unique identifier
    /// - Returns: race results for driver finished races
    public func racesFinished(driverRef: String) async throws -> [SQLRow] {
        let sql: SQLQueryString = """
        select rr.year, rr.country, rr.countryFlag, r.circuitName, r.name as raceName,
               rr.grid, rr.position, rr.grid - rr.position as positionsGained,
               rr.constructorColor, sc.name, sc.mainColor, s.status
          from gpsRaceResults rr
          join gpsRaces r on r.raceRef = rr.raceRef
          join gpsDrivers d on d.driverRef = rr.driverRef
          join gpsSeasonConstructors sc on sc.constructorRef = rr.constructorRef and sc.year = rr.year
          join status s on rr.statusId = s.statusId
         where rr.driverRef = \(bind: driverRef)
           and (s.statusId = 1 or s.status like '%Lap%')
         order by rr.raceRef desc
        """
        return try await execute(sql)
    }

}
