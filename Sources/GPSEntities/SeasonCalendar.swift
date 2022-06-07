//
//  SeasonCalendar.swift
//  GPSModels
//
//  Created by Eneko Alonso on 5/29/22.
//

import Foundation

public struct SeasonCalendar {
    public static let currentYear = Calendar.current.dateComponents([.year], from: Date()).year ?? 2022
    public static let seasons = 1950...currentYear
}
