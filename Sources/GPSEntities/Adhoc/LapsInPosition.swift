//
//  File.swift
//  
//
//  Created by Eneko on 6/27/22.
//

import Foundation

public struct LapsInPosition: Codable {
    public init(name: String, mainColor: String, raceName: String, position: Int, lapsInPosition: Int) {
        self.name = name
        self.mainColor = mainColor
        self.raceName = raceName
        self.position = position
        self.lapsInPosition = lapsInPosition
    }

    public let name: String
    public let mainColor: String
    public let raceName: String
    public let position: Int
    public let lapsInPosition: Int
}
