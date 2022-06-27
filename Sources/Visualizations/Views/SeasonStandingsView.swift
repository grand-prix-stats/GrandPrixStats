//
//  SeasonStandingsView.swift
//  Visualizations
//
//  Created by Eneko Alonso on 5/14/22.
//

import SwiftUI

public struct SeasonStandingsView: View {
    public static let defaultSize: CGSize = .init(width: 2200, height: 1800)

    public init(title: String, year: Int, seasonStandings: [Round]) {
        self.title = title
        self.year = year
        self.seasonStandings = seasonStandings
    }

    let title: String
    let year: Int
    var seasonStandings: [Round]

    public var body: some View {
        let columnWidth = 320.0
        let rowHeight = 64.0
        let rowSpacing = 6.0
        VStack(spacing: 10) {
            TitleView(title: title, subtitle: "\(year) Season")

            HStack(spacing: columnWidth) {
                ForEach(seasonStandings, id: \.round) { roundStandings in
                    VStack {
                        Text("round \(roundStandings.round)")
                            .font(.conthrax(25))
                            .fixedSize()
                        Text(roundStandings.name.uppercased())
                            .font(.conthrax(32))
                            .fixedSize()
                    }
                    .frame(width: columnWidth, height: rowHeight)
                }
            }

            ZStack {
                LineChartView(
                    lineSeries: dataSeries,
                    drawPoints: false,
                    inverted: true,
                    zeroBased: false,
                    lineWidth: 10,
                    lineSteps: (left: 0.35, right: 0.35 )
                )
                .frame(
                    width: columnWidth * CGFloat(2 * seasonStandings.count - 2),
                    height: (rowHeight + rowSpacing) * CGFloat(seasonStandings[0].standings.count - 1)
                )

                HStack(spacing: columnWidth) {
                    ForEach(seasonStandings, id: \.round) { roundStandings in
                        VStack(spacing: rowSpacing) {
                            ForEach(roundStandings.standings, id: \.position) { standing in
                                ConstructorColoredLabel(
                                    constructorColor: standing.mainColor.color,
                                    text: standing.name,
                                     subtext: standing.points.formattedPoints
                                )
                                .frame(width: columnWidth, height: rowHeight)
                            }
                        }
                    }
                }
            }
        }
//        .frame(
//            height: 200 + (rowHeight + rowSpacing) * CGFloat(seasonStandings[0].standings.count)
//        )
    }

    var dataSeries: [DataSeries] {
        seasonStandings.last?.standings.map { standing -> DataSeries in
            let positions = seasonStandings.map { roundStandings -> CGFloat in
                CGFloat(roundStandings.standings.first { $0.name == standing.name }?.position ?? 0)
            }
            return DataSeries(
                id: standing.name,
                color: standing.mainColor.color,
                points: positions
            )
        } ?? []
    }
}

struct SeasonStandingsView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonStandingsView(
            title: "Driver Standings",
            year: 2020,
            seasonStandings: [
                Round(
                    round: 1,
                    name: "ABC 🏴‍☠️",
                    standings: [
                        DriverRoundStanding(position: 1, name: "FOO", points: 10, mainColor: "#FF0000"),
                        DriverRoundStanding(position: 2, name: "BAR", points:  8, mainColor: "#FF8800"),
                        DriverRoundStanding(position: 3, name: "BAZ", points:  5, mainColor: "#008800"),
                        DriverRoundStanding(position: 4, name: "BA2", points:  4, mainColor: "#008800"),
                        DriverRoundStanding(position: 5, name: "BA3", points:  3, mainColor: "#008800"),
                        DriverRoundStanding(position: 6, name: "BA4", points:  2, mainColor: "#008800"),
                        DriverRoundStanding(position: 7, name: "BA5", points:  1, mainColor: "#008800"),
                        DriverRoundStanding(position: 8, name: "BA6", points:  0, mainColor: "#008800"),
                        DriverRoundStanding(position: 9, name: "BA7", points:  0, mainColor: "#008800"),
                    ]
                ),
                Round(
                    round: 2,
                    name: "FIN 🏁",
                    standings: [
                        DriverRoundStanding(position: 1, name: "BAR", points: 18, mainColor: "#FF8800"),
                        DriverRoundStanding(position: 2, name: "FOO", points: 15, mainColor: "#FF0000"),
                        DriverRoundStanding(position: 3, name: "BAZ", points: 12, mainColor: "#008800"),
                        DriverRoundStanding(position: 4, name: "BA2", points:  4, mainColor: "#008800"),
                        DriverRoundStanding(position: 5, name: "BA3", points:  3, mainColor: "#008800"),
                        DriverRoundStanding(position: 6, name: "BA4", points:  2, mainColor: "#008800"),
                        DriverRoundStanding(position: 7, name: "BA5", points:  1, mainColor: "#008800"),
                        DriverRoundStanding(position: 8, name: "BA6", points:  0, mainColor: "#008800"),
                        DriverRoundStanding(position: 9, name: "BA7", points:  0, mainColor: "#008800"),
                    ]
                ),
                Round(
                    round: 3,
                    name: "ANT 🇫🇲",
                    standings: [
                        DriverRoundStanding(position: 1, name: "FOO", points: 25, mainColor: "#FF0000"),
                        DriverRoundStanding(position: 2, name: "BAZ", points: 23, mainColor: "#008800"),
                        DriverRoundStanding(position: 3, name: "BAR", points: 21, mainColor: "#FF8800"),
                        DriverRoundStanding(position: 4, name: "BA2", points:  4, mainColor: "#008800"),
                        DriverRoundStanding(position: 5, name: "BA3", points:  3, mainColor: "#008800"),
                        DriverRoundStanding(position: 6, name: "BA4", points:  2, mainColor: "#008800"),
                        DriverRoundStanding(position: 7, name: "BA5", points:  1, mainColor: "#008800"),
                        DriverRoundStanding(position: 8, name: "BA6", points:  0, mainColor: "#008800"),
                        DriverRoundStanding(position: 9, name: "BA7", points:  0, mainColor: "#008800"),
                    ]
                ),
                Round(
                    round: 4,
                    name: "🇫🇲",
                    standings: [
                        DriverRoundStanding(position: 1, name: "FOO", points: 25, mainColor: "#FF0000"),
                        DriverRoundStanding(position: 2, name: "BAZ", points: 23, mainColor: "#008800"),
                        DriverRoundStanding(position: 3, name: "BAR", points: 21, mainColor: "#FF8800"),
                        DriverRoundStanding(position: 4, name: "BA2", points:  4, mainColor: "#008800"),
                        DriverRoundStanding(position: 5, name: "BA3", points:  3, mainColor: "#008800"),
                        DriverRoundStanding(position: 6, name: "BA4", points:  2, mainColor: "#008800"),
                        DriverRoundStanding(position: 7, name: "BA5", points:  1, mainColor: "#008800"),
                        DriverRoundStanding(position: 8, name: "BA6", points:  0, mainColor: "#008800"),
                        DriverRoundStanding(position: 9, name: "BA7", points:  0, mainColor: "#008800"),
                    ]
                ),
                Round(
                    round: 5,
                    name: "🇫🇲",
                    standings: [
                        DriverRoundStanding(position: 1, name: "FOO", points: 25, mainColor: "#FF0000"),
                        DriverRoundStanding(position: 2, name: "BAZ", points: 23, mainColor: "#008800"),
                        DriverRoundStanding(position: 3, name: "BAR", points: 21, mainColor: "#FF8800"),
                        DriverRoundStanding(position: 4, name: "BA2", points:  4, mainColor: "#008800"),
                        DriverRoundStanding(position: 5, name: "BA3", points:  3, mainColor: "#008800"),
                        DriverRoundStanding(position: 6, name: "BA4", points:  2, mainColor: "#008800"),
                        DriverRoundStanding(position: 7, name: "BA5", points:  1, mainColor: "#008800"),
                        DriverRoundStanding(position: 8, name: "BA6", points:  0, mainColor: "#008800"),
                        DriverRoundStanding(position: 9, name: "BA7", points:  0, mainColor: "#008800"),
                    ]
                ),
                Round(
                    round: 6,
                    name: "🇫🇲",
                    standings: [
                        DriverRoundStanding(position: 1, name: "FOO", points: 25, mainColor: "#FF0000"),
                        DriverRoundStanding(position: 2, name: "BAZ", points: 23, mainColor: "#008800"),
                        DriverRoundStanding(position: 3, name: "BAR", points: 21, mainColor: "#FF8800"),
                        DriverRoundStanding(position: 4, name: "BA2", points:  4, mainColor: "#008800"),
                        DriverRoundStanding(position: 5, name: "BA3", points:  3, mainColor: "#008800"),
                        DriverRoundStanding(position: 6, name: "BA4", points:  2, mainColor: "#008800"),
                        DriverRoundStanding(position: 7, name: "BA5", points:  1, mainColor: "#008800"),
                        DriverRoundStanding(position: 8, name: "BA6", points:  0, mainColor: "#008800"),
                        DriverRoundStanding(position: 9, name: "BA7", points:  0, mainColor: "#008800"),
                    ]
                ),
            ]
        )
    }
}

public struct Round {
    public init(round: Int, name: String, standings: [DriverRoundStanding]) {
        self.round = round
        self.name = name
        self.standings = standings
    }

    let round: Int
    let name: String
    let standings: [DriverRoundStanding]
}

public struct DriverRoundStanding {
    public init(position: Int, name: String, points: Double, mainColor: String) {
        self.position = position
        self.name = name
        self.points = points
        self.mainColor = mainColor
    }

    let position: Int
    let name: String
    let points: Double
    let mainColor: String
}
