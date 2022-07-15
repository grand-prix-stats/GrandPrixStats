//
//  LapTimesByDurationView.swift
//  
//
//  Created by Eneko on 7/14/22.
//

import SwiftUI
import GPSEntities

public struct LapTimesByDurationView: View {
    public static let defaultSize = CGSize(width: 2000, height: 2000)

    let year: Int
    let race: String
    let flag: String

    var rows = [
        Row(
            name: "ALO",
            values: [(10, 10), (11, 10), (12, 15), (13, 1)],
            color: .blue,
            positionOrder: 1
        ),
        Row(
            name: "HAM",
            values: [(12, 10), (13, 8), (11, 17)],
            color: .cyan,
            positionOrder: 2
        ),
    ]

    let labelWidth = 220.0
    let labelSpacing = 20.0

    public init(year: Int, dataSet: [LapsByDuration]) {
        self.year = year
        race = dataSet.first?.raceName ?? "[RACE]"
        flag = dataSet.first?.countryFlag ?? ""
        rows = Self.rows(from: dataSet)
    }

    init() {
        year = 2022
        race = "Foo Race"
        flag = "🏁"
    }

    public var body: some View {
        VStack(spacing: 50) {
            Title2View(
                title: "Distribution of Driver Lap Times",
                subtitle: "\(year) \(race) \(flag)"
            )

            let xes = rows.flatMap { $0.values.map(\.0) }
            let minX = xes.min() ?? 0
            let maxX = xes.max() ?? 0
            VStack(spacing: 16) {
                HStack(spacing: labelSpacing) {
                    Text("")
                        .frame(width: labelWidth)
                    HStack {
                        ForEach(Int(minX)...Int(maxX), id: \.self) { duration in
                            Text("\(duration)s")
                                .frame(maxWidth: .infinity)
                        }
                        .font(.terminator(48))
                        .minimumScaleFactor(0.1)
                    }
                }
                ForEach(rows, id: \.name) { row in
                    HStack(spacing: labelSpacing) {
                        Text(row.name)
                            .font(.goodTiming(64))
                            .minimumScaleFactor(0.1)
                            .frame(width: labelWidth)
                        BarChartView(
                            values: row.values,
                            minX: minX,
                            maxX: maxX,
                            color: row.color,
                            cornerRadius: 8
                        )
                    }
                }
            }
        }
        .padding()
    }

    struct Row {
        let name: String
        let values: [(Double, Double)]
        let color: Color
        let positionOrder: Int
    }

    static func rows(from dataSet: [LapsByDuration]) -> [Row] {
        let keys = Set(dataSet.map(\.name))
        let rows = keys.map { key -> Row in
            let values = dataSet
                .filter { $0.name == key }
                .map { (Double($0.seconds), Double($0.lapCount)) }
            let entry = dataSet.first { $0.name == key }
            let color = entry?.mainColor.color ?? Color.black
            let positionOrder = entry?.positionOrder ?? .max
            return .init(
                name: key,
                values: values,
                color: color,
                positionOrder: positionOrder
            )
        }
        return rows.sorted(using: KeyPathComparator(\.positionOrder))
    }
}

struct LapTimesByDurationView_Previews: PreviewProvider {
    static var previews: some View {
        LapTimesByDurationView()
    }
}
