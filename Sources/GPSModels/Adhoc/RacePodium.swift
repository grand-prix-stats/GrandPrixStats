//
//  RacePodium.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/23/22.
//

import Foundation

public struct RacePodium: Codable {
    public init(
        raceRef: String,
        year: Int,
        round: Int,
        circuitName: String,
        country: String,
        countryFlag: String,
        raceName: String,
        laps: Int,
        p1: String,
        p2: String,
        p3: String,
        p1Time: String,
        p2Time: String,
        p3Time: String,
        p1Milliseconds: Int,
        p2Milliseconds: Int,
        p3Milliseconds: Int,
        p1ConstructorColor: String,
        p2ConstructorColor: String,
        p3ConstructorColor: String
    ) {
        self.raceRef = raceRef
        self.year = year
        self.round = round
        self.circuitName = circuitName
        self.country = country
        self.countryFlag = countryFlag
        self.raceName = raceName
        self.laps = laps
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        self.p1Time = p1Time
        self.p2Time = p2Time
        self.p3Time = p3Time
        self.p1Milliseconds = p1Milliseconds
        self.p2Milliseconds = p2Milliseconds
        self.p3Milliseconds = p3Milliseconds
        self.p1ConstructorColor = p1ConstructorColor
        self.p2ConstructorColor = p2ConstructorColor
        self.p3ConstructorColor = p3ConstructorColor
    }

    public let raceRef: String
    public let year: Int
    public let round: Int
    public let circuitName: String
    public let country: String
    public let countryFlag: String
    public let raceName: String
    public let laps: Int
    public let p1: String
    public let p2: String
    public let p3: String
    public let p1Time: String
    public let p2Time: String
    public let p3Time: String
    public let p1Milliseconds: Int
    public let p2Milliseconds: Int
    public let p3Milliseconds: Int
    public let p1ConstructorColor: String
    public let p2ConstructorColor: String
    public let p3ConstructorColor: String
}
