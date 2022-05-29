//
//  ErgastConstructorResult.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/15/22.
//

import Foundation

/// Ergast BD table: consturctorResults
public struct ErgastConstructorResult: Codable {
    let constructorResultsId: Int
    let raceId: Int
    let constructorId: Int
    let points: Float
    let status: String
}
