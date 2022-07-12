//
//  ParsingTests.swift
//  
//
//  Created by Eneko on 7/11/22.
//

import XCTest
import Gzip

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
        XCTAssertEqual(try XCTUnwrap(components.nanosecond), 41_000_000, accuracy: 1000)
    }

    let trackStatus = """
        00:07:29.041{"Status":"2","Message":"Yellow"}
        00:07:42.541{"Status":"4","Message":"SCDeployed"}
        00:14:35.528{"Status":"1","Message":"AllClear"}
        01:39:03.793{"Status":"2","Message":"Yellow"}
        01:39:07.326{"Status":"1","Message":"AllClear"}
        01:39:09.347{"Status":"2","Message":"Yellow"}
        01:39:18.240{"Status":"1","Message":"AllClear"}
        01:39:31.886{"Status":"2","Message":"Yellow"}
        01:39:35.425{"Status":"1","Message":"AllClear"}
        """

    let position = """
        00:03:43.019"7ZOxCsIwEIbf5ea0JNerqdmdFeygFYciHYK0lTZOIe9u9AXMTTpkOQh8hLv/7vNwmFfr7DyBuXho7Tisrh8fYAAlYiF1oWSr0EgyhCWRrpsaOxCwm9xihxWMB/UuR9e7Z3zCfmqX/naPyAmMFHD+1C7WIKBKRykdrdPRTTqqJINlZKAYkylOv006i4zZEBksY8HIyKFi5EuMf0kzroxzZowcdHIPIYjvjjbRUSTKjmZHs6N/6WhVStS01VnRrGhW9BeKXsML"
        00:03:44.219"7ZM9DsIwDEbv4rlFiW2SNjszSHTgRwwV6lChtoiGqerdKVyAeILBi6VIT5H92W+C3TC2sR16COcJqrZrxlh3dwiABjE3PremshgMB6YVG89U0gky2PTx0TYjhAnsu+xjHZ/LE7Z99aivtwU5QDAZHD/1tNQ5A0pHOR1dp6MuHbVGwAoysILJrKTfIp1FwWyIAlawYBTkQIJ8WfAve8GVSc5MkINP7mGes++OusJT6bw6qo6qo3/pKK+M80SlKqqKqqJ/qiiiJ8tOHVVH1dFfOHqZXw=="
        """

    func testParseTrackStatus() throws {
        let events: [RaceEvent<TrackStatus>] = try RaceEventParser().events(
            from: Data(trackStatus.utf8),
            isZipped: false
        )
        XCTAssertEqual(events.count, 9)
        XCTAssertEqual(events.first?.event.message, "Yellow")
        XCTAssertEqual(events.last?.event.status, "1")
    }

    func testParsePosition() throws {
        let events: [RaceEvent<Position>] = try RaceEventParser().events(
            from: Data(position.utf8),
            isZipped: true
        )
        XCTAssertEqual(events.count, 2)
//        XCTAssertEqual(events.first?.event.message, "Yellow")
//        XCTAssertEqual(events.last?.event.status, "1")
    }
}

struct Position: Codable {

}

struct TrackStatus: Codable {
    let status: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }
}

struct RaceEvent<T: Codable>: Codable {
    let timeOffset: Date
    let event: T
}

struct RaceEventParser {
    let formatter = ISO8601DateFormatter()

    init() {
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
    }

    func events<T: Codable>(from data: Data, isZipped: Bool) throws -> [RaceEvent<T>] {
        let lines = String(data: data, encoding: .utf8)?.split(separator: "\n") ?? []
        let timeOffsetLen = 12 // 00:00:00.000
        return try lines.compactMap { line in
            guard let timeOffset = formatter.date(from: "2000-01-01T" + line.prefix(timeOffsetLen) + "Z") else {
                return nil
            }
            let event: T = try parse(text: line.dropFirst(timeOffsetLen), isZipped: isZipped)
            return RaceEvent(timeOffset: timeOffset, event: event)
        }
    }

    func parse<T: Codable>(text: Substring, isZipped: Bool) throws -> T {
        let eventData: Data
        if isZipped {
            var text = text
            if text.prefix(1) == "\"" {
                text = text.dropFirst().dropLast()
            }
            eventData = try Data(base64Encoded: String(text))!.gunzipped(wBits: -MAX_WBITS)
        } else {
            eventData = Data(text.utf8)
        }
        return try JSONDecoder().decode(T.self, from: eventData)
    }
}
