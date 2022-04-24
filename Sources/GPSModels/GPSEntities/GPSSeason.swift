//
//  GPSSeason.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/15/22.
//

import Foundation

/// DB Table: gpsSeasons
public struct GPSSeason: Codable {
    public let year: Int
    public let rounds: Int
    public let startDate: Date
    public let endDate: Date
    public let driversChampionRef: String?
    public let constructorsChampionRef: String?
    public let constructorChamtionsColor: String?
}
