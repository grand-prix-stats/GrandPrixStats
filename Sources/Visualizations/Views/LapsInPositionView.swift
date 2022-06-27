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
    let positions: ClosedRange<Int>

    public init(dataSet: [LapsInPosition]) {
        self.dataSet = dataSet
        let maxPosition = dataSet.map(\.position).max() ?? 1
        positions = 1...maxPosition
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("")
                    .frame(width: 100)
                ForEach(positions, id: \.self) { position in
                    Text("\(position)")
                        .frame(width: 50)
                }
            }
            ForEach(rows) { row in
                HStack(spacing: 0) {
                    Text(row.title)
                        .frame(width: 100)
                    ForEach(row.values, id: \.self) { value in
                        if let value = value {
                            Text("\(value)")
                                .frame(width: 50)
                        } else {
                            Color.clear
                                .frame(width: 50)
                        }
                    }
                }
                .background(row.color)
                .frame(height: 50)
            }
        }
    }

    struct Row: Identifiable {
        let title: String
        let color: Color
        let values: [Int?]
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
            let color = dataSet.first { $0.name == key }?.mainColor.color ?? Color.black
            return .init(title: key, color: color, values: values)
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
