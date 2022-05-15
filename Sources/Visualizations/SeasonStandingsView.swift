//
//  SeasonStandingsView.swift
//  Visualizations
//
//  Created by Eneko Alonso on 5/14/22.
//

import SwiftUI
import GPSModels

public protocol RoundStandings {
    var round: Int { get }
    var name: String { get }
    var standings: [Standing] { get }
}

public protocol Standing {
    var position: Int { get }
    var name: String { get }
    var points: Double { get }
    var mainColor: String { get }
}

public struct SeasonStandingsView: View {
    public init(title: String, year: Int, seasonStandings: [RoundStandings]) {
        self.title = title
        self.year = year
        self.seasonStandings = seasonStandings
    }

    let title: String
    let year: Int
    var seasonStandings: [RoundStandings]

    public var body: some View {
        let columnWidth = 300.0
        let rowHeight = 64.0
        let rowSpacing = 6.0
        VStack(spacing: 0) {
            TitleView(title: title, subtitle: "\(year) Season")

            HStack(spacing: columnWidth) {
                ForEach(seasonStandings, id: \.round) { roundStandings in
                    VStack {
                        Text("round \(roundStandings.round)")
                            .font(.conthrax(25))
                        Text(roundStandings.name)
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
                    width: columnWidth * CGFloat(seasonStandings.count + 1),
                    height: rowHeight * CGFloat(seasonStandings[0].standings.count - 1)
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
            year: 2022,
            seasonStandings: [
                RoundPreview(
                    round: 1,
                    name: "🏴‍☠️",
                    standings: [
                        StandingPreview(position: 1, name: "FOO", points: 10, mainColor: "#FF0000"),
                        StandingPreview(position: 2, name: "BAR", points:  8, mainColor: "#FF8800"),
                        StandingPreview(position: 3, name: "BAZ", points:  5, mainColor: "#008800"),
                    ]
                ),
                RoundPreview(
                    round: 2,
                    name: "🏁",
                    standings: [
                        StandingPreview(position: 1, name: "BAR", points: 18, mainColor: "#FF8800"),
                        StandingPreview(position: 2, name: "FOO", points: 15, mainColor: "#FF0000"),
                        StandingPreview(position: 3, name: "BAZ", points: 12, mainColor: "#008800"),
                    ]
                ),
                RoundPreview(
                    round: 3,
                    name: "🇫🇲",
                    standings: [
                        StandingPreview(position: 1, name: "FOO", points: 25, mainColor: "#FF0000"),
                        StandingPreview(position: 2, name: "BAZ", points: 23, mainColor: "#008800"),
                        StandingPreview(position: 3, name: "BAR", points: 21, mainColor: "#FF8800"),
                    ]
                )
            ]
        )
    }
}

struct RoundPreview: RoundStandings {
    let round: Int
    let name: String
    let standings: [Standing]
}

struct StandingPreview: Standing {
    let position: Int
    let name: String
    let points: Double
    let mainColor: String
}
