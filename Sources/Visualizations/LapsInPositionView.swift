//
//  LapsInPositionView.swift
//  
//
//  Created by Eneko on 6/27/22.
//

import SwiftUI
import GPSEntities

public struct LapsInPositionView: View {
    let lapsInPosition: [LapsInPosition]

    init(lapsInPosition: [LapsInPosition]) {
        self.lapsInPosition = lapsInPosition
    }

    public var body: some View {
        VStack {
            HStack {
                Text("10")
            }
        }
    }

    var rows: [String: [String]] {
        let keys = Set(lapsInPosition.map(\.name))
        let maxPosition = lapsInPosition.map(\.position).max() ?? 1
        
    }
}

struct LapsInPositionView_Previews: PreviewProvider {
    static var previews: some View {
        LapsInPositionView(lapsInPosition: [
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
                name: "Foo",
                mainColor: "#ABCDEF",
                raceName: "Bar Race",
                position: 8,
                lapsInPosition: 5
            ),
        ])
    }
}
