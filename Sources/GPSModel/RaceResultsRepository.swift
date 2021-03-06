//
//  RaceResultsRepository.swift
//  Database
//
//  Created by Eneko Alonso on 4/21/22.
//

import Foundation
import SQLKit
import GPSEntities

public class RaceResultsRepository: Repository {
    public func lastestPodiums(year: Int, round: Int, number: Int = 5) async throws -> [RacePodium] {
        let sql: SQLQueryString = """
        select r.raceRef,
               r.year,
               r.round,
               r.circuitName,
               r.country,
               r.countryFlag,
               r.name as raceName,
               r.raceLaps as laps,
               (select surname from gpsDrivers where driverRef = rr1.driverRef) as p1,
               (select surname from gpsDrivers where driverRef = rr2.driverRef) as p2,
               (select surname from gpsDrivers where driverRef = rr3.driverRef) as p3,
               rr1.time as p1Time,
               rr2.time as p2Time,
               rr3.time as p3Time,
               rr1.milliseconds as p1Milliseconds,
               rr2.milliseconds as p2Milliseconds,
               rr3.milliseconds as p3Milliseconds,
               rr1.constructorColor as p1ConstructorColor,
               rr2.constructorColor as p2ConstructorColor,
               rr3.constructorColor as p3ConstructorColor
          from gpsRaceResults rr1
          join gpsRaceResults rr2 on rr1.raceRef = rr2.raceRef
          join gpsRaceResults rr3 on rr1.raceRef = rr3.raceRef
          join gpsRaces r on r.raceRef = rr1.raceRef
         where rr1.circuitRef = (select circuitRef from gpsRaces where year = \(bind: year) and round = \(bind: round))
           and rr1.`position` = 1
           and rr2.`position` = 2
           and rr3.`position` = 3
         order by rr1.year desc
         limit 0,5;
        """
        return try await execute(sql)
    }

    public func finishedRaces(driverRef: String, number: Int = 25) async throws -> [SQLRow] {
        let sql: SQLQueryString = """
        select rr.year, rr.country, rr.countryFlag, rr.grid, rr.position, rr.constructorColor
          from gpsRaceResults rr
          join gpsDrivers d on d.driverRef = rr.driverRef
         where rr.driverRef = \(bind: driverRef)
           and statusId = 1
         order by rr.raceRef desc;
        """
        return try await execute(sql)
    }
}
