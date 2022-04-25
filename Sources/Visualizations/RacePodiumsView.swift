//
//  RacePodiumsView.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import SwiftUI
import GPSModels

public struct RacePodiumsView: View {
    var racePodiums: [RacePodium]

    public init(racePodiums: [RacePodium]) {
        self.racePodiums = racePodiums
    }

    public var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Last \(racePodiums.count) Podiums at")
                    .font(.conthrax(22))
                Text(racePodiums.first?.circuitName ?? "[CIRCUIT]")
                    .font(.goodTiming(64))
            }
            VStack(spacing: 40) {
                ForEach(racePodiums, id: \.raceRef) { racePodium in
                    HStack {
                        VStack {
                            Text(String(racePodium.year))
                                .font(.conthrax(50))
                            Text("round \(racePodium.round)")
                                .font(.conthrax(25))
                        }
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
                    .font(.conthrax(22))
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
            .font(.terminator(20))
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

struct RacePodiumsView_Previews: PreviewProvider {
    static var previews: some View {
        RacePodiumsView(racePodiums: imola)
            .frame(width: 1024, height: 1024)
    }

    static var imola: [RacePodium] {
        [
            RacePodium(
                raceRef: "202101",
                year: 2021,
                round: 1,
                circuitName: "Imola",
                country: "Italy",
                countryFlag: "🇮🇹",
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
                raceRef: "202002",
                year: 2020,
                round: 2,
                circuitName: "Imola",
                country: "Italy",
                countryFlag: "🇮🇹",
                raceName: "Emilia Romagna Grand Prix",
                laps: 68,
                p1: "Räikkönen",
                p2: "Hülkenberg",
                p3: "Pérez",
                p1Time: "2:02:34.598",
                p2Time: "+20s",
                p3Time: "+25s",
                p1Milliseconds: 100,
                p2Milliseconds: 120,
                p3Milliseconds: 125,
                p1ConstructorColor: "#558800",
                p2ConstructorColor: "#345678",
                p3ConstructorColor: "#443377"
            ),
            RacePodium(
                raceRef: "202003",
                year: 1999,
                round: 3,
                circuitName: "Imola",
                country: "Italy",
                countryFlag: "🇮🇹",
                raceName: "Emilia Romagna Grand Prix",
                laps: 68,
                p1: "PABLO MONTOYA",
                p2: "Hülkenberg",
                p3: "Pérez",
                p1Time: "2:02:34.598",
                p2Time: "+20s",
                p3Time: "+25s",
                p1Milliseconds: 100,
                p2Milliseconds: 120,
                p3Milliseconds: 125,
                p1ConstructorColor: "#558800",
                p2ConstructorColor: "#345678",
                p3ConstructorColor: "#443377"
            ),
        ]
    }
}
