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
               lt.position, count(1) as lapsInPosition,
               rr.position as finalPosition,
               (select avg(position) from gpsLapTimes where raceId = lt.raceId and driverRef = lt.driverRef) as averagePosition,
               r.name as raceName, r.countryFlag
          from gpsLapTimes lt
          join gpsDrivers d on lt.driverRef = d.driverRef
          join gpsRaces r on r.year = lt.year and r.round = lt.round
          join gpsRaceResults rr on lt.year = rr.year and lt.round = rr.round and lt.driverRef = rr.driverRef
         where lt.year = \(bind: year)
           and lt.round = \(bind: round)
         group by d.driverRef, lt.position, rr.position, averagePosition, r.name, r.countryFlag
        """
        return try await execute(sql)
    }

    public func lapsByDuration(year: Int, round: Int) async throws -> [LapsByDuration] {
        let sql: SQLQueryString = """
        select d.code as name, d.mainColor,
               floor(lt.milliseconds/\(bind: LapsByDuration.timeScaleMilliseconds)) as seconds,
               count(1) as lapCount,
               rr.position as finalPosition,
               rr.positionOrder,
               lt.raceAverageLapMilliseconds,
               r.name as raceName, r.countryFlag
          from gpsLapTimes lt
          join gpsDrivers d on lt.driverRef = d.driverRef
          join gpsRaces r on r.year = lt.year and r.round = lt.round
          join gpsRaceResults rr on lt.year = rr.year and lt.round = rr.round and lt.driverRef = rr.driverRef
         where lt.year = \(bind: year)
           and lt.round = \(bind: round)
           and lt.milliseconds < r.fastestLapMillis * 1.1
         group by d.driverRef, seconds, finalPosition, positionOrder,
               raceAverageLapMilliseconds, r.name, r.countryFlag
        """
        return try await execute(sql)
    }
}
