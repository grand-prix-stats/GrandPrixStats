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
    /// Driver standings before and after the last race
    public func driverStandings(year: Int, round: Int) async throws -> [DriverStanding] {
        let sql: SQLQueryString = """
        select dl.driverRef,
               dl.surname,
               dl.code,
               dl.permanentNumber,
               dsl.points,
               sdl.mainColor,
               @position := (select position from gpsDriverStandings t where t.driverRef = dl.driverRef and t.raceRef = dsl.raceRef) as position,
               @lastPosition := (select position from gpsDriverStandings t where t.driverRef = dl.driverRef and t.year = dsl.year and t.round = dsl.round - 1) as lastPosition,
               cast(@lastPosition - @position as signed) as positionDelta,

               dp.driverRef as previousDriverRef,
               dp.surname as previousSurname,
               dp.code as previousCode,
               dp.permanentNumber as previousPermanentNumber,
               dsp.points as previousPoints,
               sdp.mainColor as previousMainColor,

               rl.name as raceName,
               rl.countryFlag as raceFlag,
               rl.date as raceDate,
               rl.year,
               rl.round
          from gpsDriverStandings dsl
          left join gpsDriverStandings dsp on dsl.position = dsp.position and dsl.year = dsp.year and dsl.round = dsp.round + 1
          join gpsRaces rl on dsl.raceRef = rl.raceRef
          join gpsDrivers dl on dl.driverRef = dsl.driverRef
          left join gpsDrivers dp on dp.driverRef = dsp.driverRef
          join gpsSeasonDrivers sdl on sdl.year = dsl.year and sdl.driverRef = dsl.driverRef
          left join gpsSeasonDrivers sdp on sdp.year = dsp.year and sdp.driverRef = dsp.driverRef
         where rl.raceRef = (select raceRef from gpsRaces where year = \(bind: year) and round = \(bind: round))
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
               scl.mainColor,
               @position := (select position from gpsConstructorStandings t where t.constructorRef = cl.constructorRef and t.raceRef = rl.raceRef) as position,
               @lastPosition := (select position from gpsConstructorStandings t where t.constructorRef = cl.constructorRef and t.year = csl.year and t.round = csl.round - 1) as lastPosition,
               cast(@lastPosition - @position as signed) as positionDelta,

               cp.constructorRef as previousConstructorRef,
               cp.name as previousName,
               csp.points as previousPoints,
               scp.mainColor as previousMainColor,

               rl.name as raceName,
               rl.countryFlag as raceFlag,
               rl.date as raceDate,
               rl.year,
               rl.round
          from gpsConstructorStandings csl
          left join gpsConstructorStandings csp on csl.position = csp.position and csl.year = csp.year and csl.round = csp.round + 1
          join gpsRaces rl on csl.raceRef = rl.raceRef
          join gpsConstructors cl on cl.constructorRef = csl.constructorRef
          left join gpsConstructors cp on cp.constructorRef = csp.constructorRef
          join gpsSeasonConstructors scl on scl.year = rl.year and scl.constructorRef = csl.constructorRef
          left join gpsSeasonConstructors scp on scp.year = rl.year and scp.constructorRef = csp.constructorRef
         where rl.raceRef = (select raceRef from gpsRaces where year = \(bind: year) and round = \(bind: round))
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
