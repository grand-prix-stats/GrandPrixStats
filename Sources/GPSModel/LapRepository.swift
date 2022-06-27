//
//  LapRepository.swift
//  GPSModel
//
//  Created by Eneko on 6/24/22.
//

import Foundation
import GPSEntities
import SQLKit

public class LapRepository: Repository {

    public func lapsByPosition(year: Int, round: Int) async throws -> [LapsInPosition] {
        let sql: SQLQueryString = """
        select d.code as name, d.mainColor,
               position, count(1) as lapsInPosition
        -- ,
           --     r.name as raceName, r.country, r.countryFlag
          from gpsLapTimes lt
          join gpsDrivers d on lt.driverRef = d.driverRef
          join gpsRaces r on r.year = lt.year and r.round = lt.round
         where lt.year = \(bind: year)
           and lt.round = \(bind: round)
         group by d.driverRef, position
        """
        return try await execute(sql)
    }
}
