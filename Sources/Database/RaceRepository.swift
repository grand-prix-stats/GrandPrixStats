//
//  File.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import Foundation
import SQLKit
import GPSModels

protocol Repository {
    var database: SQLDatabase { get }
}

extension Repository {
    func execute(_ sql: SQLQueryString) throws -> [SQLRow] {
        try database.raw(sql).all().wait()
    }

    func execute<T: Decodable>(_ sql: SQLQueryString) throws -> [T] {
        try database.raw(sql).all(decoding: T.self).wait()
    }
}

public struct RaceRepository: Repository {

    public init() throws {
        try MySQL.shared.connect()
    }

    var database: SQLDatabase {
        MySQL.shared.sql
    }

    public func lastestPodiums(year: Int, round: Int, number: Int = 5) throws -> [RacePodium] {
        let sql: SQLQueryString = """
        select rr1.year,
               r.circuitName,
               r.country,
               r.countryFlag,
               r.name as raceName,
               rr1.laps,
               (select surname from gpsDrivers where driverRef = rr1.driverRef) as p1,
               (select surname from gpsDrivers where driverRef = rr2.driverRef) as p2,
               (select surname from gpsDrivers where driverRef = rr3.driverRef) as p3,
               rr1.time as p1Time,
               rr2.time as p2Time,
               rr3.time as p3Time,
               rr1.milliseconds as p1Milliseconds,
               rr2.milliseconds as p2Milliseconds,
               rr3.milliseconds as p3Milliseconds,
               (select mainColor from gpsSeasonConstructors where constructorRef = rr1.constructorRef and year = rr1.year) as p1ConstructorColor,
               (select mainColor from gpsSeasonConstructors where constructorRef = rr2.constructorRef and year = rr2.year) as p2ConstructorColor,
               (select mainColor from gpsSeasonConstructors where constructorRef = rr3.constructorRef and year = rr3.year) as p3ConstructorColor
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

        return try execute(sql) as [RacePodium]
    }
}
