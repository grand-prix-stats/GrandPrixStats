//
//  File.swift
//  
//
//  Created by Eneko Alonso on 4/30/22.
//

import Foundation
import SQLKit
import GPSModels

public final class StandingsRepository: Repository {
    /// Driver standings before and after the last race
    public func driverStandings() async throws -> [DriverStanding] {
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
               @previousPosition - @lastPosition as positionDelta,
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
         where rl.raceRef = (select raceRef from gpsRaces where winningDriverId is not null order by raceRef desc limit 0,1)
           and rp.raceRef = (select raceRef from gpsRaces where winningDriverId is not null order by raceRef desc limit 1,1)
         order by dsl.position;
        """
        return try await execute(sql)
    }

    /// Constructor standings before and after the last race
    public func constructorStandings() async throws -> [ConstructorStanding] {
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
               @previousPosition - @lastPosition as positionDelta,
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
         where rl.raceRef = (select raceRef from gpsRaces where winningDriverId is not null order by raceRef desc limit 0,1)
           and rp.raceRef = (select raceRef from gpsRaces where winningDriverId is not null order by raceRef desc limit 1,1)
         order by csl.position;
        """
        return try await execute(sql)
    }
}
