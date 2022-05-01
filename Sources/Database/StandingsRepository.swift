//
//  File.swift
//  
//
//  Created by Eneko Alonso on 4/30/22.
//

import Foundation
import SQLKit

public final class StandingsRepository: Repository {
    public func driverStandings() async throws -> [SQLRow] {
        let sql: SQLQueryString = """
        select d.driverRef, d.forename, d.surname, d.code, d.permanentNumber, d.countryFlag, d.mainColor,
               dsp.position, dsp.points,
               dsl.position, dsl.points,
               dsp.position - dsl.position as positionDelta,
               dsl.points - dsp.points as pointDelta
          from gpsDrivers d
          join gpsDriverStandings dsp on d.driverRef = dsp.driverRef
          join gpsDriverStandings dsl on d.driverRef = dsl.driverRef
         where dsp.raceId = (select raceId from gpsRaces where winningDriverId is not null order by raceRef desc limit 1,1)
           and dsl.raceId = (select raceId from gpsRaces where winningDriverId is not null order by raceRef desc limit 0,1)
         order by dsl.position
        """
        return try await execute(sql)
    }
}
