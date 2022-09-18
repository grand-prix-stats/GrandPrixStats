//
//  LineChartView.swift
//  
//
//  Created by Eneko Alonso on 5/9/22.
//

import Foundation
import SwiftUI

public struct DataSeries: Identifiable {
    public init(id: String, color: Color, points: [CGFloat?]) {
        self.id = id
        self.color = color
        self.points = points
    }

    public let id: String
    public let color: Color
    public let points: [CGFloat?]
}

public struct LineChartView: View {
    public typealias LineSteps = (left: CGFloat, right: CGFloat)
    public init(
        lineSeries: [DataSeries],
        drawPoints: Bool,
        inverted: Bool,
        zeroBased: Bool,
        lineWidth: CGFloat,
        lineSteps: LineSteps = (0,0)
    ) {
        self.lineSeries = lineSeries
        self.drawPoints = drawPoints
        self.inverted = inverted
        self.zeroBased = zeroBased
        self.lineWidth = lineWidth
        self.lineSteps = lineSteps
    }

    var lineSeries: [DataSeries]
    var drawPoints: Bool
    var inverted: Bool
    var zeroBased: Bool
    var lineWidth: CGFloat
    var lineSteps: LineSteps

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
                            guard let point = point else {
                                return
                            }
                            let currentX = CGFloat(index) * columnWidth
                            let currentY = yCoord(chartHeight: geometry.size.height, rowHeight: rowHeight, point: point)

                            if index == 0 {
                                path.move(to: .init(x: currentX, y: currentY))
                            } else if let previousPoint = series.points[index-1] {
                                let previousX = CGFloat(index - 1) * columnWidth
                                let previousY = yCoord(chartHeight: geometry.size.height, rowHeight: rowHeight, point: previousPoint)

                                let stepL = lineSteps.left * columnWidth
                                let stepR = lineSteps.right * columnWidth

                                path.addLine(to: .init(x: previousX + stepL, y: previousY))
                                path.addLine(to: .init(x: currentX - stepR, y: currentY))
                                path.addLine(to: .init(x: currentX, y: currentY))
                            } else {
                                path.move(to: .init(x: currentX, y: currentY))
                            }
                        }
                    }
                    .strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, dash: []))
                    .foregroundColor(series.color)

                    if drawPoints {
                        ForEach(points, id: \.offset) { (index, point) in
                            if let point = point {
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
        lineSeries.flatMap(\.points).compactMap { $0 }.max() ?? 0
    }
    var minY: CGFloat {
        lineSeries.flatMap(\.points).compactMap { $0 }.min() ?? 0
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(
            lineSeries: Self.pairs,
            drawPoints: false,
            inverted: false,
            zeroBased: false,
            lineWidth: 15,
            lineSteps: (0, 0)
        )
            .frame(width: 800, height: 400)
        LineChartView(lineSeries: Self.standings, drawPoints: false, inverted: true, zeroBased: false, lineWidth: 25)
            .frame(width: 500, height: 500)
        LineChartView(lineSeries: Self.points, drawPoints: true, inverted: false, zeroBased: true, lineWidth: 10)
            .frame(width: 500, height: 500)
    }

    static var pairs: [DataSeries] {
        [
            DataSeries(id: "1", color: .blue, points: [0,0]),
            DataSeries(id: "2", color: .teal, points: [0,10]),
            DataSeries(id: "3", color: .pink, points: [10,0]),
            DataSeries(id: "4", color: .mint, points: [5,5]),
            DataSeries(id: "5", color: .orange, points: [2,8]),
        ]
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
            ),
            DataSeries(
                id: "4",
                color: .purple,
                points: [nil, 8, nil, 10, 7]
            ),
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
            ),
            DataSeries(
                id: "3",
                color: .pink,
                points: [0, 15, nil, 35, 35]
            ),
        ]
    }
}
