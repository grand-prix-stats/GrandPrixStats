//
//  ConstructorStanding.swift
//  GPSModels
//
//  Created by Eneko Alonso on 5/1/22.
//

import Foundation

public struct ConstructorStanding: Codable {
    public init(
        constructorRef: String,
        name: String,
        points: Double,
        mainColor: String,
        position: Int,
        lastPosition: Int?,
        positionDelta: Int?,
        previousConstructorRef: String?,
        previousName: String?,
        previousPoints: Double?,
        previousMainColor: String?,
        raceName: String,
        raceFlag: String,
        raceDate: Date,
        year: Int,
        round: Int
    ) {
        self.constructorRef = constructorRef
        self.name = name
        self.points = points
        self.mainColor = mainColor
        self.position = position
        self.lastPosition = lastPosition
        self.positionDelta = positionDelta
        self.previousConstructorRef = previousConstructorRef
        self.previousName = previousName
        self.previousPoints = previousPoints
        self.previousMainColor = previousMainColor
        self.raceName = raceName
        self.raceFlag = raceFlag
        self.raceDate = raceDate
        self.year = year
        self.round = round
    }

    public let constructorRef: String
    public let name: String
    public let points: Double
    public let mainColor: String
    public let position: Int
    public let lastPosition: Int?
    public let positionDelta: Int?
    public let previousConstructorRef: String?
    public let previousName: String?
    public let previousPoints: Double?
    public let previousMainColor: String?
    public let raceName: String
    public let raceFlag: String
    public let raceDate: Date
    public let year: Int
    public let round: Int
}
