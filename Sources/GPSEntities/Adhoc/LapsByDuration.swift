//
//  LapsByDuration.swift
//  
//
//  Created by Eneko on 7/8/22.
//

import Foundation

public struct LapsByDuration: Codable {
    public static let timeScaleMilliseconds = 100
    
    public init(name: String, mainColor: String, seconds: Int, lapCount: Int, finalPosition: Int?, positionOrder: Int, raceAverageLapMilliseconds: Int, raceName: String, countryFlag: String) {
        self.name = name
        self.mainColor = mainColor
        self.seconds = seconds
        self.lapCount = lapCount
        self.finalPosition = finalPosition
        self.positionOrder = positionOrder
        self.raceAverageLapMilliseconds = raceAverageLapMilliseconds
        self.raceName = raceName
        self.countryFlag = countryFlag
    }

    public let name: String
    public let mainColor: String
    public let seconds: Int
    public let lapCount: Int
    public let finalPosition: Int?
    public let positionOrder: Int
    public let raceAverageLapMilliseconds: Int
    public let raceName: String
    public let countryFlag: String
}
