//
//  GPSRaceResult.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/15/22.
//

import Foundation

/// DB Table: gpsRaceResults
public struct GPSRaceResult {
    public let raceRef: String
    public let driverRef: String
    public let circuitRef: String
    public let country: String
    public let position: Int?
    public let points: Double?
}
