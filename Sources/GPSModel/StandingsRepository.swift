//
//  File.swift
//  
//
//  Created by Eneko Alonso on 4/30/22.
//

import Foundation
import SQLKit
import GPSEntities

public final class StandingsRepository: Repository {
    //          where rl.raceRef = (select raceRef from gpsRaces where winningDriverId is not null order by raceRef desc limit 0,1)
    //    and rp.raceRef = (select raceRef from gpsRaces where winningDriverId is not null order by raceRef desc limit 1,1)

    /// Driver standings before and after the last race
    public func driverStandings(year: Int, round: Int) async throws -> [DriverStanding] {
        let sql: SQLQueryString = """
        select dl.driverRef,
               dl.surname,
               dl.code,
               dl.permanentNumber,
               dsl.points,
               dl.mainColor,
               @lastPosition := (select position from gpsDriverStandings where driverRef = dl.driverRef and raceRef = rl.raceRef) as position,
               dp.driverRef as previousDriverRef,
               dp.surname as previousSurname,
               dp.code as previousCode,
               dp.permanentNumber as previousPermanentNumber,
               dsp.points as previousPoints,
               dp.mainColor as previousMainColor,
               @previousPosition := (select position from gpsDriverStandings where driverRef = dl.driverRef and raceRef = rp.raceRef) as previousPosition,
               cast(@previousPosition - @lastPosition as signed) as positionDelta,
               rl.name as raceName,
               rl.countryFlag as raceFlag,
               rl.date as raceDate,
               rl.year,
               rl.round
          from gpsRaces rl
          join gpsRaces rp
          join gpsDriverStandings dsl on dsl.raceRef = rl.raceRef
          join gpsDriverStandings dsp on dsp.raceRef = rp.raceRef and dsl.position = dsp.position
          join gpsDrivers dl on dl.driverRef = dsl.driverRef
          join gpsDrivers dp on dp.driverRef = dsp.driverRef
         where rl.raceRef = (select raceRef from gpsRaces where year = \(bind: year) and round = \(bind: round))
           and rp.raceRef = (select raceRef from gpsRaces where year = \(bind: year) and round = \(bind: round - 1))
         order by dsl.position;
        """
        return try await execute(sql)
    }

    /// Constructor standings before and after the last race
    public func constructorStandings(year: Int, round: Int) async throws -> [ConstructorStanding] {
        let sql: SQLQueryString = """
        select cl.constructorRef,
               cl.name,
               csl.points,
               cl.mainColor,
               @lastPosition := (select position from gpsConstructorStandings where constructorRef = cl.constructorRef and raceRef = rl.raceRef) as position,
               cp.constructorRef as previousConstructorRef,
               cp.name as previousName,
               csp.points as previousPoints,
               cp.mainColor as previousMainColor,
               @previousPosition := (select position from gpsConstructorStandings where constructorRef = cl.constructorRef and raceRef = rp.raceRef) as previousPosition,
               cast(@previousPosition - @lastPosition as signed) as positionDelta,
               rl.name as raceName,
               rl.countryFlag as raceFlag,
               rl.date as raceDate,
               rl.year,
               rl.round
          from gpsRaces rl
          join gpsRaces rp
          join gpsConstructorStandings csl on csl.raceRef = rl.raceRef
          join gpsConstructorStandings csp on csp.raceRef = rp.raceRef and csl.position = csp.position
          join gpsConstructors cl on cl.constructorRef = csl.constructorRef
          join gpsConstructors cp on cp.constructorRef = csp.constructorRef
         where rl.raceRef = (select raceRef from gpsRaces where year = \(bind: year) and round = \(bind: round))
           and rp.raceRef = (select raceRef from gpsRaces where year = \(bind: year) and round = \(bind: round - 1))
         order by csl.position;
        """
        return try await execute(sql)
    }

    /// Load driver standings for an entire season, race by race. Includes non-competed races, if any
    public func driverSeasonStandings(year: Int) async throws -> [SimpleDriverStanding] {
        let sql: SQLQueryString = """
        select r.round, r.name as raceName, r.country as raceCountry, r.countryFlag as raceFlag,
               sd.driverRef, sd.forename, sd.surname, sd.code, sd.permanentNumber, sd.mainColor,
               ifnull(ds.position, (select max(position) from gpsDriverStandings where year = sd.year)) as position,
               ifnull(ds.points, 0) as points
          from gpsSeasonDrivers sd
          join gpsRaces r on r.year = sd.year
          left join gpsDriverStandings ds on ds.driverRef = sd.driverRef and ds.raceRef = r.raceRef
         where sd.year = \(bind: year)
           and r.winningDriverId is not null
        """
        return try await execute(sql)
    }

    /// Load driver standings for an entire season, race by race up to a given round. Includes non-competed races, if any
    public func driverSeasonStandings(year: Int, fromRound: Int, toRound: Int) async throws -> [SimpleDriverStanding] {
        let sql: SQLQueryString = """
        select r.round, r.name as raceName, r.country as raceCountry, r.countryFlag as raceFlag,
               sd.driverRef, sd.forename, sd.surname, sd.code, sd.permanentNumber, sd.mainColor,
               ifnull(ds.position, (select max(position) from gpsDriverStandings where year = sd.year)) as position,
               ifnull(ds.points, 0) as points
          from gpsSeasonDrivers sd
          join gpsRaces r on r.year = sd.year
          left join gpsDriverStandings ds on ds.driverRef = sd.driverRef and ds.raceRef = r.raceRef
         where r.year = \(bind: year)
           and r.round >= \(bind: fromRound)
           and r.round <= \(bind: toRound)
           and r.winningDriverId is not null
        """
        return try await execute(sql)
    }
}

public struct SimpleDriverStanding: Codable {
    public init(round: Int, raceName: String, raceCountry: String, raceFlag: String, driverRef: String, forename: String, surname: String, code: String, permanentNumber: Int?, mainColor: String, position: Int, points: Double) {
        self.round = round
        self.raceName = raceName
        self.raceCountry = raceCountry
        self.raceFlag = raceFlag
        self.driverRef = driverRef
        self.forename = forename
        self.surname = surname
        self.code = code
        self.permanentNumber = permanentNumber
        self.mainColor = mainColor
        self.position = position
        self.points = points
    }

    public let round: Int
    public let raceName: String
    public let raceCountry: String
    public let raceFlag: String
    public let driverRef: String
    public let forename: String
    public let surname: String
    public let code: String
    public let permanentNumber: Int?
    public let mainColor: String
    public let position: Int
    public let points: Double
}
