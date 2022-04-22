//
//  RacePodiumsView.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import SwiftUI

public struct RacePodiumsView: View {
    var racePodiums: RacePodiums

    public init(racePodiums: RacePodiums) {
        self.racePodiums = racePodiums
    }

    public var body: some View {
        VStack(spacing: 30) {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Text("Circuit")
                        .font(.system(size: 16, weight: .medium))
                    Text(racePodiums.circuitName)
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                }
                Text("Last 5 Podiums")
            }
            VStack(spacing: 20) {
                ForEach(racePodiums.racePodiums, id: \.year) { racePodium in
                    HStack {
                        Text(String(racePodium.year))
                            .font(.system(size: 50, weight: .heavy))
                            .frame(width: 180)

                        VStack(alignment: .leading) {
                            HStack {
                                Text("1st")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 30)
                                    .foregroundColor(Color.yellow)
                                Text(racePodium.p1Driver)
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                            }
                            HStack {
                                Text("2nd")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 30)
                                    .foregroundColor(Color.gray)
                                Text(racePodium.p2Driver)
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                            }
                            HStack {
                                Text("3rd")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 30)
                                    .foregroundColor(Color.orange)
                                Text(racePodium.p3Driver)
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RacePodiumsView_Previews: PreviewProvider {
    static var previews: some View {
        RacePodiumsView(racePodiums: .imola)
            .frame(width: 1024, height: 768)
    }
}

public struct RacePodiums {
    struct RacePodium {
        let raceName: String
        let year: Int
        let p1Driver: String
        let p2Driver: String
        let p3Driver: String
    }

    let circuitName: String
    let racePodiums: [RacePodium]
}

extension RacePodiums {
    public static let imola = RacePodiums(
        circuitName: "Imola",
        racePodiums: [
            RacePodium(
                raceName: "Emilia Romagna Grand Prix",
                year: 2021,
                p1Driver: "VER 🇳🇱",
                p2Driver: "HAM 🇬🇧",
                p3Driver: "NOR 🇬🇧"
            ),
            RacePodium(
                raceName: "Emilia Romagna Grand Prix",
                year: 2020,
                p1Driver: "HAM 🇬🇧",
                p2Driver: "BOT 🇫🇮",
                p3Driver: "RIC 🇦🇺"
            ),
            RacePodium(
                raceName: "San Marino Grand Prix",
                year: 2006,
                p1Driver: "MSC 🇩🇪",
                p2Driver: "ALO 🇪🇸",
                p3Driver: "MON 🇨🇴"
            ),
            RacePodium(
                raceName: "San Marino Grand Prix",
                year: 2005,
                p1Driver: "ALO 🇪🇸",
                p2Driver: "MSC 🇩🇪",
                p3Driver: "WUR 🇦🇹"
            ),
            RacePodium(
                raceName: "San Marino Grand Prix",
                year: 2004,
                p1Driver: "MSC 🇩🇪",
                p2Driver: "BUT 🇬🇧",
                p3Driver: "MON 🇨🇴"
            ),
        ]
    )
}
