//
//  RacePodiumsView.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import SwiftUI
import GPSModels

public struct RacePodiumsView: View {
    public static let preferredSize = CGSize(width: 1200, height: 1800)
    var circuitName: String
    var racePodiums: [RacePodium]

    public init(circuitName: String, racePodiums: [RacePodium]) {
        self.circuitName = circuitName
        self.racePodiums = racePodiums
    }

    public var body: some View {
        VStack(spacing: 30) {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    ZStack {
                        Text(circuitName)
                            .font(.custom("Good Timing", size: 64))
                    }
                }
                Text("Last \(racePodiums.count) Podiums")
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
            }
            VStack(spacing: 40) {
                ForEach(racePodiums, id: \.year) { racePodium in
                    HStack {
                        Text(String(racePodium.year))
                            .font(.custom("Conthrax", size: 50))
                            .frame(width: 180)

                        VStack {
                            HStack(spacing: 0) {
                                OrdinalPosition(position: "1st", color: .yellow)
                                ConstructorColoredLabel(
                                    constructorColor: Color(cssColor: racePodium.p1ConstructorColor),
                                    text: racePodium.p1,
                                    subtext: racePodium.p1Time
                                )
                            }
                            HStack(spacing: 0) {
                                OrdinalPosition(position: "2nd", color: .gray)
                                ConstructorColoredLabel(
                                    constructorColor: Color(cssColor: racePodium.p2ConstructorColor),
                                    text: racePodium.p2,
                                    subtext: racePodium.p2Time
                                )
                            }
                            HStack(spacing: 0) {
                                OrdinalPosition(position: "3rd", color: .orange)
                                ConstructorColoredLabel(
                                    constructorColor: Color(cssColor: racePodium.p3ConstructorColor),
                                    text: racePodium.p3,
                                    subtext: racePodium.p3Time
                                )
                            }
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Text("@GrandPrixStats")
                    .font(.custom("Conthrax", size: 22))
                    .font(.custom("Good Timing", size: 22))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct OrdinalPosition: View {
    var position: String
    var color: Color
    var body: some View {
        Text(position.uppercased())
            .font(.custom("Terminator", size: 20))
            .frame(width: 100)
            .foregroundColor(color)
    }
}

struct ConstructorColoredLabel: View {
    var constructorColor: Color
    var text: String
    var subtext: String
    var body: some View {
        ZStack {
            constructorColor
            HStack(alignment: .firstTextBaseline) {
                Text(text.uppercased() + " ")
                    .font(.custom("Good Timing", size: 50))
//                    .font(.custom("Into Deep", size: 50))
                Spacer()
                Text(subtext)
                    .font(.custom("Conthrax", size: 32))
            }
            .foregroundColor(constructorColor.brightnessLevel > 0.5 ? .black : .white)
            .padding([.leading, .trailing])
        }
    }
}

struct RacePodiumsView_Previews: PreviewProvider {
    static var previews: some View {
        RacePodiumsView(circuitName: "Imola", racePodiums: imola)
            .frame(width: 1024, height: 768)
    }

    static var imola: [RacePodium] {
        [
            RacePodium(
                year: 2021,
                raceName: "Emilia Romagna Grand Prix",
                laps: 68,
                p1: "VERSTAPPEN",
                p2: "HAMILTON",
                p3: "NORRIS",
                p1Time: "1h2m3s",
                p2Time: "+20s",
                p3Time: "+25s",
                p1Milliseconds: 100,
                p2Milliseconds: 120,
                p3Milliseconds: 125,
                p1ConstructorColor: "#ff8800",
                p2ConstructorColor: "#123456",
                p3ConstructorColor: "#554477"
            ),
            RacePodium(
                year: 2020,
                raceName: "Emilia Romagna Grand Prix",
                laps: 68,
                p1: "Räikkönen",
                p2: "Hülkenberg",
                p3: "Pérez",
                p1Time: "1h2m3s",
                p2Time: "+20s",
                p3Time: "+25s",
                p1Milliseconds: 100,
                p2Milliseconds: 120,
                p3Milliseconds: 125,
                p1ConstructorColor: "#558800",
                p2ConstructorColor: "#345678",
                p3ConstructorColor: "#443377"
            )
        ]
    }
}
