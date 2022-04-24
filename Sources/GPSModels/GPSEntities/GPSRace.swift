//
//  GPSRace.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/15/22.
//

import Foundation

/// DB Table: gpsRaces
public struct GPSRace: Codable {
    public let raceRef: String
    public let year: Int
    public let round: Int
    public let name: String
    public let date: Date
    public let time: Int?
    public let circuitRef: String
    public let circuitName: String
    public let country: String
    public let countryCode: String
    public let countryFlag: String
    public let winningDriverRef: String?
    public let winningConstrucrotRef: String?
    public let winningConstructorName: String?
    public let winningConstructorColor: String?
}
