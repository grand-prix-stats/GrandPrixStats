//
//  DriverStanding.swift
//  GPSModels
//
//  Created by Eneko Alonso on 5/1/22.
//

import Foundation

public struct DriverStanding: Codable {
    public init(
        driverRef: String,
        surname: String,
        code: String,
        permanentNumber: Int?,
        points: Double,
        mainColor: String,
        position: Int,
        lastPosition: Int?,
        positionDelta: Int?,
        previousDriverRef: String?,
        previousSurname: String?,
        previousCode: String?,
        previousPermanentNumber: Int?,
        previousPoints: Double?,
        previousMainColor: String?,
        raceName: String,
        raceFlag: String,
        raceDate: Date,
        year: Int,
        round: Int
    ) {
        self.driverRef = driverRef
        self.surname = surname
        self.code = code
        self.permanentNumber = permanentNumber
        self.points = points
        self.mainColor = mainColor
        self.position = position
        self.lastPosition = lastPosition
        self.positionDelta = positionDelta
        self.previousDriverRef = previousDriverRef
        self.previousSurname = previousSurname
        self.previousCode = previousCode
        self.previousPermanentNumber = previousPermanentNumber
        self.previousPoints = previousPoints
        self.previousMainColor = previousMainColor
        self.raceName = raceName
        self.raceFlag = raceFlag
        self.raceDate = raceDate
        self.year = year
        self.round = round
    }

    public let driverRef: String
    public let surname: String
    public let code: String
    public let permanentNumber: Int?
    public let points: Double
    public let mainColor: String
    public let position: Int
    public let lastPosition: Int?
    public let positionDelta: Int?
    public let previousDriverRef: String?
    public let previousSurname: String?
    public let previousCode: String?
    public let previousPermanentNumber: Int?
    public let previousPoints: Double?
    public let previousMainColor: String?
    public let raceName: String
    public let raceFlag: String
    public let raceDate: Date
    public let year: Int
    public let round: Int
}
