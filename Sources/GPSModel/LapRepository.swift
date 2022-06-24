//
//  File.swift
//  
//
//  Created by Eneko on 6/24/22.
//

import Foundation
import SQLKit

public struct LapsInPosition: Decodable {
    let name: String
    let mainColor: String
    let raceName: String
    let position: Int
    let lapsInPosition: Int
}

public class LapRepository: Repository {

    func lapsByPosition(year: Int, round: Int) async throws -> [LapsInPosition] {
        let sql: SQLQueryString = """
        select d.driverRef, d.surname, d.code, d.mainColor,
               position, count(1) as lapsInPosition,
               r.name, r.country, r.countryFlag
          from gpsLapTimes lt
          join gpsDrivers d on lt.driverRef = d.driverRef
          join gpsRaces r on r.year = lt.year and r.round = lt.round
         where lt.year = 2022
           and lt.round = 9
         group by driverRef, position;
        """
        return try await execute(sql)
    }
}
