//
//  File.swift
//  
//
//  Created by Eneko on 7/8/22.
//

import Foundation

public struct LapsByDuration: Codable {
    public init(name: String, mainColor: String, raceName: String, seconds: Int, lapCount: Int) {
        self.name = name
        self.mainColor = mainColor
        self.seconds = seconds
        self.lapCount = lapCount
    }

    public let name: String
    public let mainColor: String
    public let seconds: Int
    public let lapCount: Int
}
