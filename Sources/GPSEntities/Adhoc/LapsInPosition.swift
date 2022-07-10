//
//  File.swift
//  
//
//  Created by Eneko on 6/27/22.
//

import Foundation

public struct LapsInPosition: Codable {
    public init(name: String, mainColor: String, position: Int, lapsInPosition: Int, averagePosition: Double, finalPosition: Int?, raceName: String, countryFlag: String) {
        self.name = name
        self.mainColor = mainColor
        self.position = position
        self.lapsInPosition = lapsInPosition
        self.averagePosition = averagePosition
        self.finalPosition = finalPosition
        self.raceName = raceName
        self.countryFlag = countryFlag
    }

    public let name: String
    public let mainColor: String
    public let position: Int
    public let lapsInPosition: Int
    public let averagePosition: Double
    public let finalPosition: Int?
    public let raceName: String
    public let countryFlag: String
}
