import SwiftUI

struct ConstructorColoredLabel: View {
    var constructorColor: Color
    var text: String
    var subtext: String
    var body: some View {
        ZStack {
            constructorColor
            HStack(alignment: .firstTextBaseline) {
                Text(text.uppercased() + " ")
                    .font(.goodTiming(50))
                Spacer()
                Text(subtext)
                    .font(.conthrax(36))
            }
            .foregroundColor(constructorColor.brightnessLevel > 0.5 ? .black : .white)
            .padding([.leading, .trailing])
        }
    }
}
