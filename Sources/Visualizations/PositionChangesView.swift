//
//  PositionChangesView.swift
//  
//
//  Created by Eneko Alonso on 6/27/22.
//

import SwiftUI

struct PositionChangesView: View {
    var positions: [String] {
        (1...20).reversed().map(String.init)
    }
    var body: some View {
        VStack {
            HStack {
                Text("")
                ForEach(positions, id: \.self) {
                    Text($0)
                }
            }
            HStack {
                Text("AUS 🇦🇺")
                HStack {
                }
            }
        }
    }
}

struct PositionChangesView_Previews: PreviewProvider {
    static var previews: some View {
        PositionChangesView()
    }
}
