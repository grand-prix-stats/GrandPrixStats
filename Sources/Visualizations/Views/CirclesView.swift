//
//  CirclesView.swift
//
//
//  Created by Eneko on 7/14/22.
//

import SwiftUI

struct CirclesView: View {
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

    var body: some View {
        let minX = self.minX ?? values.map(\.0).min() ?? 0
        let maxX = self.maxX ?? values.map(\.0).max() ?? 0
        GeometryReader { geometry in
            let xRatio = (maxX - minX) / geometry.size.width
            let yRatio = geometry.size.height / maxY

            ZStack {
                ForEach(values.indices, id: \.self) { index in
                    let item = values[index]
                    Circle()
                        .frame(
                            height: item.1 * yRatio
                        )
                        .offset(
                            x: item.0 * xRatio,
                            y: 0
                        )
                        .foregroundColor(color)
                        .opacity(0.2)
                }
            }
//            .frame(height: maxHeight)
        }
    }
}

struct CirclesView_Previews: PreviewProvider {
    static var previews: some View {
//        CirclesView()
        CirclesView(
            values: [(10, 10), (12, 20)]
        )
//        CirclesView(
//            values: [(10, 10), (30, 15), (60, 20)],
//            minX: 0,
//            maxX: 100,
//            color: .blue
//        )
    }
}
