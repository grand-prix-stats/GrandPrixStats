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
        00:03:45.019"7ZOxDoIwEIbf5eZC2utBsTuzJjIoxoEYhsYABupE+u6iL2Bv0qHLJU2+NHf/3bfCYVqcd9MI9rJC44Z+8d3wAAsoETNpMiUbhVaSJcqpNGgqbEFAPfrZ9QvYFdS7HH3nn9sT9mMzd7f7hpzASgHnT223GgToeJTi0SIeLeNRJRksIwPFmExx+q3iWWTMhshgGQtGRg6akS8x/iXDuDLOmTFyMNE9hCC+O1qhQdSUHE2OJkf/0tEil2jUTidFk6JJ0V8oeg0v"
        00:03:46.040"7ZOxCsIwEIbf5ea03CVpE7M7K9hBKw5FOgSxlTZOJe9u9QXMTTpkOQh8hLv/7ltgP84++HEAd16g8fd+Dt39AQ4kSlmgKQgbkg6101WpakOadAsCtkOYfD+DW4De5RC68FyfsBuaqbveVuQIDgWcPrVdaxSg0lGdjlbpaJ2OEjJYRgbEmIw4/dp0VjJmk5LBMhYsGTkoRr6a8a82jCvjnBkjB5PcQ4ziu6MGDdqNyY5mR7Ojf+loXaK2qIzNjmZHs6O/cPQSXw=="
        00:03:47.359"7ZOxCsIwEIbf5ea0JJc0abM7K9hBKw5FOgRpK22cSt7d6AuYm3QIhIPAR7j7c98Gh3l13s0T2MsGrRuH1ffjAywgRyy4KQRvBVqurNJlhabRqumAwW7yixtWsBuIdzn63j/jFfZTu/S3e0ROYDmD86d2sQYGMh1V6WiVjup0VHACS8hAECYTlH7rdBYJsyESWMIHIyEHSchXEd5VhrBllDUj5GCSewiBfXe04SYekR3NjmZH/9JRU0ptamkwO5odzY7+wtFreAE="
        00:03:48.359"7ZXBCsIwDIbfJedtNFnX1N49K7iDTjwM8TBkU1w9jb270xewOekhl0DhoyR/89EJtrexi91tgHCcoO76yxjb/g4ByBDlhnM0NVIwNlguKsMeq1UDGayH+OguI4QJ8F12sY3P5QiboX605+uC7CGYDA6f2ix1zqBMR206WqWjLh1FI2AFGaBgMpT069NZEsxGJGAFD0yCHEpBvlZwr2XBlknWTJADJ/cwz9l3R71jdkjqqDqqjv6lo75Az4zk1FF1VB39U0dLx85X+o+qo+roTxw9zS8="
        00:03:49.259"7ZM9DsIwDEbv4rmgxHXiNjszSHTgRwwV6lChtoiGqerdKVyAeILBi6VIT5H92W+C3TC2sR16COcJqrZrxlh3dwiABnFleGVNZTEYClSsnWfvqDhBBps+PtpmhDCBfZd9rONzecK2rx719bYgBwgmg+OnnpY6Z5Cno5SOunTUp6PWCFhBBlYwmZX0W6SzKJgNUcAKFoyCHHJBviT4l1hwZZIzE+TAyT3Mc/bdUSb2yKSOqqPq6J86WiJ7Y3J1VB1VR//S0XKNnh2V6qg6qo7+xNHL/AI="
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
        XCTAssertEqual(events.count, 7)
        XCTAssertNotNil(events.first?.event.position.first?.timestamp)
        XCTAssertEqual(events.first?.event.position.first?.entries["1"]?.status, "OnTrack")
    }
}

struct Position: Codable {
    let position: [PositionEntries]

    struct PositionEntries: Codable {
        let timestamp: Date
        let entries: [String: Entry]

        struct Entry: Codable {
            let status: String
            let x: Double
            let y: Double
            let z: Double
        }
    }
}

struct TrackStatus: Codable {
    let status: String
    let message: String
}

struct RaceEvent<T: Codable>: Codable {
    let timeOffset: Date
    let event: T
}

struct RaceEventParser {
    let decoder = JSONDecoder()
    let formatter = ISO8601DateFormatter()

    init() {
        formatter.formatOptions =  [.withFractionalSeconds]
        decoder.keyDecodingStrategy = .convertFromPascalCase
        decoder.dateDecodingStrategy = .custom { [formatter] decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date \(string)")
            }
            return date
        }
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
        return try decoder.decode(T.self, from: eventData)
    }
}

struct PascalCaseKey: CodingKey {
    let stringValue: String
    let intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue.prefix(1).lowercased() + stringValue.dropFirst()
        intValue = nil
    }

    init(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    static var convertFromPascalCase: Self {
        .custom { keys in
            PascalCaseKey(stringValue: keys.last!.stringValue)
        }
    }
}
