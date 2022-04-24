//
//  Circuit.swift
//  GPSModels
//
//  Created by Eneko Alonso on 4/15/22.
//

import Foundation

/// Ergast DB table: circuits
public struct Circuit: Codable {
    let circuitId: Int
    let circuitRef: String
    let name: String
    let location: String
    let country: String
    let lat: Float
    let lng: Float
    let alt: Int?
    let url: String
}
