//
//  LapsByDuration.swift
//  
//
//  Created by Eneko on 7/8/22.
//

import Foundation

public struct LapsByDuration: Codable {
    public init(name: String, mainColor: String, seconds: Int, lapCount: Int, raceName: String, countryFlag: String) {
        self.name = name
        self.mainColor = mainColor
        self.seconds = seconds
        self.lapCount = lapCount
        self.raceName = raceName
        self.countryFlag = countryFlag
    }

    public let name: String
    public let mainColor: String
    public let seconds: Int
    public let lapCount: Int
    public let raceName: String
    public let countryFlag: String
}
