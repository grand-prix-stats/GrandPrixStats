//
//  LineChartView.swift
//  
//
//  Created by Eneko Alonso on 5/9/22.
//

import Foundation
import SwiftUI

public struct DataSeries: Identifiable {
    public init(id: String, color: Color, points: [CGFloat]) {
        self.id = id
        self.color = color
        self.points = points
    }

    public let id: String
    public let color: Color
    public let points: [CGFloat]
}

public struct LineChartView: View {
    public init(lineSeries: [DataSeries], drawPoints: Bool, inverted: Bool, zeroBased: Bool, lineWidth: CGFloat) {
        self.lineSeries = lineSeries
        self.drawPoints = drawPoints
        self.inverted = inverted
        self.zeroBased = zeroBased
        self.lineWidth = lineWidth
    }

    var lineSeries: [DataSeries]
    var drawPoints: Bool
    var inverted: Bool
    var zeroBased: Bool
    var lineWidth: CGFloat

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(lineSeries) { series in
                    let rangeY = (zeroBased ? 0 : minY)...maxY
                    let rowHeight = geometry.size.height / (rangeY.upperBound - rangeY.lowerBound)
                    let columnWidth = geometry.size.width / CGFloat(series.points.count - 1)
                    let points = Array(series.points.enumerated())

                    Path { path in
                        points.forEach { (index, point) in
                            let x = CGFloat(index) * columnWidth
                            let y = yCoord(chartHeight: geometry.size.height, rowHeight: rowHeight, point: point)
                            if index == 0 {
                                path.move(to: .init(x: x, y: y))
                            } else {
                                path.addLine(to: .init(x: x, y: y))
                            }
                        }
                    }
                    .strokedPath(.init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .foregroundColor(series.color)

                    if drawPoints {
                        ForEach(points, id: \.offset) { (index, point) in
                            let x = CGFloat(index) * columnWidth
                            let y = yCoord(chartHeight: geometry.size.height, rowHeight: rowHeight, point: point)
                            Circle()
                                .frame(width: lineWidth * 2, height: lineWidth * 2)
                                .position(x: x, y: y)
                                .foregroundColor(series.color)

                        }
                    }
                }
            }
        }
        .padding(0)
    }

    func yCoord(chartHeight: CGFloat, rowHeight: CGFloat, point: CGFloat) -> CGFloat {
        var y = point * rowHeight
        if zeroBased == false {
            y = y - minY * rowHeight
        }
        if inverted == false {
            y = chartHeight - y
        }
        return y
    }

    var maxY: CGFloat {
        lineSeries.flatMap(\.points).max() ?? 0
    }
    var minY: CGFloat {
        lineSeries.flatMap(\.points).min() ?? 0
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(lineSeries: Self.standings, drawPoints: false, inverted: true, zeroBased: false, lineWidth: 15)
            .frame(width: 500, height: 500)
        LineChartView(lineSeries: Self.points, drawPoints: true, inverted: false, zeroBased: true, lineWidth: 5)
            .frame(width: 500, height: 500)
    }

    static var standings: [DataSeries] {
        [
            DataSeries(
                id: "1",
                color: .red,
                points: [20, 6, 2, 5, 2]
            ),
            DataSeries(
                id: "2",
                color: .blue,
                points: [12, 2, 4, 4, 2]
            ),
            DataSeries(
                id: "3",
                color: .green,
                points: [1, 3, 5, 7, 9]
            )
        ]
    }

    static var points: [DataSeries] {
        [
            DataSeries(
                id: "1",
                color: .red,
                points: [0, 10, 25, 25, 41]
            ),
            DataSeries(
                id: "2",
                color: .blue,
                points: [0, 20, 38, 42, 45]
            )
        ]
    }
}
