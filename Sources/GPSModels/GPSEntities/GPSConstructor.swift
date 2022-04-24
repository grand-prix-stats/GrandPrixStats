//
//  GPSConstructor.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/15/22.
//

import Foundation

/// DB Table: gpsConstructor
public struct GPSConstructor: Codable {
    let constructorRef: String
    let seasons: Int
    let name: String
    let country: String
    let countryFlag: String
    let countryCode: String
    let wins: Int
    let podiums: Int
    let topTen: Int
    let poles: Int
    let points: Float
    let finishedInPoints: Int
    let fastestLaps: Int
    let racesFinished: Int
    let didNotFinish: Int
    let didNotStart: Int
    let firstSeason: Int
    let lastSeason: Int
    let firstRace: Date?
    let lastRace: Date?
    let firstWin: Date?
    let lastWin: Date?
    let championships: Int
    let subChampionships: Int
    let mainColor: String
    let secondaryColor: String
}
