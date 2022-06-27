//
//  StrippedBackgroundView.swift
//  Visualizations
//
//  Created by Eneko Alonso on 4/24/22.
//

import Stripes
import SwiftUI

public struct StrippedBackgroundView<Content: View>: View {
    var padding: CGFloat
    var content: () -> Content

    public init(padding: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.padding = padding
        self.content = content
    }

    public var body: some View {
        ZStack {
            Stripes(config: StripesConfig(
                background: Color.black,
                foreground: Color.white,
                degrees: 30,
                barWidth: 10,
                barSpacing: 20
            )).opacity(0.02)

            VStack(spacing: padding / 2) {
                content()
                Spacer()
                HStack {
                    Spacer()
                    Text("@GrandPrixStats")
                        .font(.conthrax(22))
                        .foregroundColor(.gray)
                }
            }
            .padding(padding)
        }
        .background(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1))
    }
}

struct StrippedBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        StrippedBackgroundView(padding: 50) {
            Text("Hello world!")
        }
    }
}
