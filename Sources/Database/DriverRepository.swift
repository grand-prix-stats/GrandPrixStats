//
//  DriverRepository.swift
//  Database
//
//  Created by Eneko Alonso on 5/1/22.
//

import Foundation
import GPSModels
import SQLKit

public class DriverRepository: Repository {

    public func drivers(byYear year: Int) async throws -> [SQLRow] {
        let sql: SQLQueryString = """
        select *
          from gpsDrivers
         where driverRef in (select driverRef from gpsDriverStandings where year = \(bind: year))
        """
        return try await execute(sql)
    }
}
