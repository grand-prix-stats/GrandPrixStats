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
    public func driverStandings() async throws -> [DriverStanding] {
        let sql: SQLQueryString = """
        select dl.driverRef,
               dl.surname,
               dl.code,
               dl.permanentNumber,
               dsl.points,
               dl.mainColor,
               dp.driverRef as previousDriverRef,
               dp.surname as previousSurname,
               dp.code as previousCode,
               dp.permanentNumber as previousPermanentNumber,
               dsp.points as previousPoints,
               dp.mainColor as previousMainColor,
               @lastPosition := (select position from gpsDriverStandings where driverRef = dl.driverRef and raceRef = rl.raceRef) as position,
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
}
