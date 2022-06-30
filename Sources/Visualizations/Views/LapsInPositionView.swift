//
//  LapsInPositionView.swift
//  
//
//  Created by Eneko on 6/27/22.
//

import SwiftUI
import GPSEntities

public struct LapsInPositionView: View {
    let dataSet: [LapsInPosition]

    let maxPosition: Int
    let positions: ClosedRange<Int>

    let nameWidth = 150.0
    let cellWidth = 70.0
    let rowHeight = 60.0

    public init(dataSet: [LapsInPosition]) {
        self.dataSet = dataSet
        maxPosition = dataSet.map(\.position).max() ?? 1
        positions = 1...maxPosition
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("")
                    .frame(width: nameWidth)
                ForEach(positions, id: \.self) { position in
                    Text("\(position)")
                        .font(.terminator(16))
                        .frame(width: cellWidth, height: rowHeight * 0.6)
                }
            }
            ForEach(rows) { row in
                HStack(spacing: 0) {
                    Text(row.title.uppercased())
                        .font(.goodTiming(40))
                        .frame(width: nameWidth, height: rowHeight)
                        .background(row.color)
                    ForEach(row.values, id: \.self) { value in
                        cellBody(value: value)
                            .font(.conthrax(32))
                            .frame(width: cellWidth, height: rowHeight)
                            .background(color(forLapsInPosition: value, total: row.total))
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
        let values: [Int?]
        let total: Int
        var id: String { title }
    }

    var rows: [Row] {
        let keys = Set(dataSet.map(\.name)).sorted()
        let rows = keys.map { key -> Row in
            let values = positions.map { position -> Int? in
                let found = dataSet.first { entry in
                    entry.name == key && entry.position == position
                }
                return found?.lapsInPosition
            }
            let total = values.compactMap { $0 }.reduce(0, +)
            let color = dataSet.first { $0.name == key }?.mainColor.color ?? Color.black
            return .init(
                title: key,
                color: color,
                values: values,
                total: total
            )
        }
        return rows
    }
}

struct LapsInPositionView_Previews: PreviewProvider {
    static var previews: some View {
        LapsInPositionView(dataSet: [
            LapsInPosition(
                name: "Foo",
                mainColor: "#ABCDEF",
                raceName: "Bar Race",
                position: 10,
                lapsInPosition: 20
            ),
            LapsInPosition(
                name: "Foo",
                mainColor: "#ABCDEF",
                raceName: "Bar Race",
                position: 9,
                lapsInPosition: 14
            ),
            LapsInPosition(
                name: "Bar",
                mainColor: "#CDEFGH",
                raceName: "Bar Race",
                position: 5,
                lapsInPosition: 30
            ),
            LapsInPosition(
                name: "Foo",
                mainColor: "#ABCDEF",
                raceName: "Bar Race",
                position: 8,
                lapsInPosition: 5
            ),
        ])
    }
}
