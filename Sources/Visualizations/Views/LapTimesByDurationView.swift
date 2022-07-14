//
//  LapTimesByDurationView.swift
//  
//
//  Created by Eneko on 7/14/22.
//

import SwiftUI

struct LapTimesByDuration {
    let name: String
    let values: [(Double, Double)]
    let color: Color
}

struct LapTimesByDurationView: View {
    let rows = [
        LapTimesByDuration(
            name: "ALO",
            values: [(10, 10), (11, 10), (12, 15), (13, 1)],
            color: .blue
        ),
        LapTimesByDuration(
            name: "HAM",
            values: [(12, 10), (13, 8), (11, 17)],
            color: .cyan
        ),
    ]

    let labelWidth = 220.0
    let labelSpacing = 20.0

    var body: some View {
        let xes = rows.flatMap { $0.values.map(\.0) }
        let minX = xes.min() ?? 0
        let maxX = xes.max() ?? 0
        VStack {
            HStack(spacing: labelSpacing) {
                Text("")
                    .frame(width: labelWidth)
                HStack {
                    ForEach(Int(minX)...Int(maxX), id: \.self) { duration in
                        Text("\(duration)")
                            .frame(maxWidth: .infinity)
                            .font(.terminator(20))
                    }
                }
            }
            ForEach(rows, id: \.name) { row in
                HStack(spacing: labelSpacing) {
                    Text(row.name)
                        .font(.goodTiming(64))
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
        .padding()
    }
}

struct LapTimesByDurationView_Previews: PreviewProvider {
    static var previews: some View {
        LapTimesByDurationView()
    }
}
