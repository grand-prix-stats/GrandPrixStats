//
//  BarChartView.swift
//  
//
//  Created by Eneko on 7/14/22.
//

import SwiftUI

struct BarChartView: View {
    var values = [
        (59.0, 12.0),
        (70.0, 18.0),
        (71.0,  2.0),
        (72.0,  3.0),
        (73.0,  0.0),
        (84.0, 15.0),
        (85.0, 10.0)
    ]

    var minX: Double? = nil
    var maxX: Double? = nil
    var maxY = 18.0

    var color = Color.red
    var cornerRadius = 155.0
    var barSpacing = 5.0

    var body: some View {
        let minX = self.minX ?? values.map(\.0).min() ?? 0
        let maxX = self.maxX ?? values.map(\.0).max() ?? 0
        let bars = 1 + maxX - minX
        GeometryReader { geometry in
            let barWidth = ((geometry.size.width + barSpacing) / bars) - barSpacing
            let maxHeight = geometry.size.height
            let yRatio = maxHeight / maxY

            ZStack {
                ForEach(values.indices, id: \.self) { index in
                    let item = values[index]
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(
                            width: barWidth,
                            height: min(maxHeight, item.1 * yRatio)
                        )
                        .offset(
                            x: (item.0 - minX) * (barWidth + barSpacing),
                            y: 0
                        )
                        .foregroundColor(color)
                }
            }
            .frame(height: maxHeight)
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView()
        BarChartView(
            values: [(10, 10), (12, 20)]
        )
        BarChartView(
            values: [(10, 10), (30, 15), (60, 20)],
            minX: 0,
            maxX: 100,
            color: .blue,
            cornerRadius: 0
        )
    }
}
