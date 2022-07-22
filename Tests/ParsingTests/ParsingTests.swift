//
//  ParsingTests.swift
//  
//
//  Created by Eneko on 7/11/22.
//

import XCTest

final class ParsingTests: XCTestCase {

    func testTimestamp() throws {
        let prefix = "2000-01-01T"
        let timestamp = "00:07:29.041"
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        let parsed = try XCTUnwrap(formatter.date(from: prefix + timestamp + "Z"))
        let components = Calendar(identifier: .gregorian).dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: parsed)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 7)
        XCTAssertEqual(components.second, 29)
    }

    func testPositionTimestamp() throws {
        let timestamp = "2022-07-10T12:04:42.4475852Z"
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        let parsed = try XCTUnwrap(formatter.date(from: timestamp))
        let components = Calendar(identifier: .gregorian).dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: parsed)
        XCTAssertEqual(components.hour, 12)
        XCTAssertEqual(components.minute, 4)
        XCTAssertEqual(components.second, 42)
    }
}
