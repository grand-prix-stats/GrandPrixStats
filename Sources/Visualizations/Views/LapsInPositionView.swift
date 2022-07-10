//
//  LapsInPositionView.swift
//  
//
//  Created by Eneko on 6/27/22.
//

import SwiftUI
import GPSEntities

public struct LapsInPositionView: View {
    public static let defaultSize = CGSize(width: 2000, height: 1600)

    let year: Int
    let dataSet: [LapsInPosition]

    let maxPosition: Int
    let positions: ClosedRange<Int>

    let positionWidth = 80.0
    let nameWidth = 150.0
    let cellWidth = 80.0
    let rowHeight = 60.0

    public init(year: Int, dataSet: [LapsInPosition]) {
        self.year = year
        self.dataSet = dataSet
        maxPosition = dataSet.map(\.position).max() ?? 1
        positions = 1...maxPosition
    }

    public var body: some View {
        VStack(spacing: 50) {
            let race = dataSet.first?.raceName ?? "[RACE]"
            let flag = dataSet.first?.countryFlag ?? ""
            Title2View(
                title: "Number of Laps Completed in Position",
                subtitle: "\(year) \(race) \(flag)"
            )

            VStack(spacing: 0) {
                HStack() {
                    Text("")
                        .frame(width: positionWidth)
                    Text("")
                        .frame(width: nameWidth)
                    HStack(spacing: 0) {
                        ForEach(positions, id: \.self) { position in
                            Text("\(position)")
                                .font(.terminator(16))
                                .frame(width: cellWidth, height: rowHeight * 0.6)
                        }
                    }
                    Text("TOTAL")
                        .font(.terminator(10))
                        .multilineTextAlignment(.center)
                        .frame(width: positionWidth, height: rowHeight * 0.6)
                }
                ForEach(rows) { row in
                    HStack() {
                        Text(row.finalPosition?.ordinal ?? "DNF")
                            .font(.conthrax(20))
                            .frame(width: positionWidth)
                        Text(row.title.uppercased())
                            .font(.goodTiming(40))
                            .frame(width: nameWidth, height: rowHeight)
                            .background(row.color)
                            .foregroundColor(row.color.foregroundTextColor)
                        HStack(spacing: 0) {
                            ForEach(row.values, id: \.position) { value in
                                cellBody(value: value.laps)
                                    .font(.conthrax(32))
                                    .frame(width: cellWidth, height: rowHeight)
                                    .background(color(forLapsInPosition: value.laps, total: row.total))
                            }
                        }
                        Text("\(row.total)")
                            .font(.conthrax(32))
                            .frame(width: positionWidth)
                    }

                }
            }
        }
    }

    @ViewBuilder
    func cellBody(value: Int?) -> some View {
        if let value = value {
            Text("\(value)")
                .frame(width: cellWidth)
        } else {
            Color.clear
                .frame(width: cellWidth)
        }
    }

    func color(forLapsInPosition value: Int?, total: Int) -> Color {
        let ratio = Double(value ?? 0) / Double(total)
        return Color(hue: 1, saturation: 1, brightness: ratio, opacity: 1)
    }

    struct Row: Identifiable {
        let title: String
        let color: Color
        let values: [(position: Int, laps: Int?)]
        let total: Int
        let averagePosition: Double
        let finalPosition: Int?
        var id: String { title }
    }

    var rows: [Row] {
        let keys = Set(dataSet.map(\.name))
        let rows = keys.map { key -> Row in
            let values = positions.map { position -> (position: Int, laps: Int?) in
                let found = dataSet.first { entry in
                    entry.name == key && entry.position == position
                }
                return (
                    position: position,
                    laps: found?.lapsInPosition
                )
            }
            let entry = dataSet.first { $0.name == key }
            let color = entry?.mainColor.color ?? Color.black
            let total = values.compactMap { $0.laps }.reduce(0, +)
            let averagePosition = entry?.averagePosition ?? .infinity
            let finalPosition = entry?.finalPosition
            return .init(
                title: key,
                color: color,
                values: values,
                total: total,
                averagePosition: averagePosition,
                finalPosition: finalPosition
            )
        }
        return rows.sorted {
            switch ($0.finalPosition, $1.finalPosition) {
            case let (.some(x), .some(y)):
                return x < y
            case let (.none, .some(y)):
                return $0.averagePosition < Double(y)
            case let (.some(x), .none):
                return Double(x) < $1.averagePosition
            case (.none, .none):
                return $0.averagePosition < $1.averagePosition
            }
        }
    }
}

struct LapsInPositionView_Previews: PreviewProvider {
    static var previews: some View {
        LapsInPositionView(
            year: 2022,
            dataSet: [
                LapsInPosition(
                    name: "a",
                    mainColor: "#aaaaaa",
                    position: 1,
                    lapsInPosition: 45,
                    averagePosition: 1,
                    finalPosition: 1,
                    raceName: "Foo Grand Prix",
                    countryFlag: "🏁"
                ),
                LapsInPosition(
                    name: "Foo",
                    mainColor: "#ABCDEF",
                    position: 10,
                    lapsInPosition: 20,
                    averagePosition: 9.5,
                    finalPosition: 8,
                    raceName: "Foo Grand Prix",
                    countryFlag: "🏁"
                ),
                LapsInPosition(
                    name: "Foo",
                    mainColor: "#ABCDEF",
                    position: 9,
                    lapsInPosition: 14,
                    averagePosition: 9.5,
                    finalPosition: 8,
                    raceName: "Foo Grand Prix",
                    countryFlag: "🏁"
                ),
                LapsInPosition(
                    name: "Bar",
                    mainColor: "#CDEFGH",
                    position: 5,
                    lapsInPosition: 30,
                    averagePosition: 5,
                    finalPosition: nil,
                    raceName: "Foo Grand Prix",
                    countryFlag: "🏁"
                ),
                LapsInPosition(
                    name: "Foo",
                    mainColor: "#ABCDEF",
                    position: 8,
                    lapsInPosition: 5,
                    averagePosition: 9.5,
                    finalPosition: 8,
                    raceName: "Foo Grand Prix",
                    countryFlag: "🏁"
                ),
            ])
    }
}
