//
//  StandingsView.swift
//  
//
//  Created by Eneko Alonso on 5/1/22.
//

import SwiftUI
import GPSModels

struct StandingsRow: View {
    var standing: DriverStanding
    var size: CGSize
    var body: some View {
        HStack {
            OrdinalPosition(position: standing.position.ordinal, color: .gray)
                .frame(width: size.width * 0.1)
            ConstructorColoredLabel(
                constructorColor: standing.previousMainColor.color,
                text: standing.previousCode,
                subtext: standing.previousPoints.formattedPoints
            )
            .frame(width: size.width * 0.3)
            Spacer()
            ConstructorColoredLabel(
                constructorColor: standing.mainColor.color,
                text: standing.code,
                subtext: standing.points.formattedPoints
            )
            .frame(width: size.width * 0.3)
            OrdinalPosition(position: standing.position.ordinal, color: .gray)
                .frame(width: size.width * 0.1)
            //            Text(String(standing.positionDelta))
        }
        .frame(height: size.height)
    }
}

public struct StandingsView: View, Visualization {
    public static let defaultSize: CGSize = .init(width: 1200, height: 1800)

    public init(standings: [DriverStanding]) {
        self.standings = standings
    }

    let standings: [DriverStanding]

    let spacing = 10.0

    public var body: some View {
            VStack {
                VStack {
                    Text("Driver Standings before and after")
                        .font(.conthrax(22))
                    let race = standings.first?.raceName ?? "[RACE]"
                    let year = standings.first.flatMap { String($0.year) } ?? ""
                    Text("\(year) \(race)")
                        .font(.goodTiming(64))
                        .multilineTextAlignment(.center)
                }

                GeometryReader { geometry in
                    let rowHeight = (geometry.size.height / CGFloat(standings.count))
                ZStack {
                    ForEach(standings, id: \.driverRef) { standing in
                        let x1 = (geometry.size.width / 2) - (geometry.size.width * 0.1)
                        let y1 = positionY(position: standing.previousPosition, rowHeight: rowHeight)
                        let x2 = (geometry.size.width / 2) + (geometry.size.width * 0.1)
                        let y2 = positionY(position: standing.position, rowHeight: rowHeight)

                        Path { path in
                            path.move(to: CGPoint(x: x1, y: y1))
                            path.addLine(to: CGPoint(x: x1+25, y: y1))
                            path.addLine(to: CGPoint(x: x2-25, y: y2))
                            path.addLine(to: CGPoint(x: x2, y: y2))
                        }
                        .strokedPath(.init(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(standing.mainColor.color)
                    }

                    VStack(spacing: spacing) {
                        ForEach(standings, id: \.driverRef) { standing in
                            StandingsRow(standing: standing, size: CGSize(width: geometry.size.width, height: rowHeight - spacing))
                        }
                    }
                }
            }
        }
    }

    func positionY(position: Int, rowHeight: CGFloat) -> CGFloat {
        rowHeight * (CGFloat(position) - 0.5)
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsView(standings: [
            DriverStanding(
                driverRef: "foo",
                surname: "Foo",
                code: "FOO",
                permanentNumber: 22,
                points: 22,
                mainColor: "#123456",
                previousDriverRef: "bar",
                previousSurname: "Bar",
                previousCode: "BAR",
                previousPermanentNumber: 33,
                previousPoints: 18,
                previousMainColor: "#234567",
                position: 1,
                previousPosition: 2,
                positionDelta: 1,
                raceName: "Foo Grand Prix",
                raceFlag: "🏁",
                raceDate: Date(),
                year: 2022,
                round: 4
            ),
            DriverStanding(
                driverRef: "bar",
                surname: "Bar",
                code: "BAR",
                permanentNumber: 33,
                points: 15,
                mainColor: "#234567",
                previousDriverRef: "foo",
                previousSurname: "Foo",
                previousCode: "FOO",
                previousPermanentNumber: 22,
                previousPoints: 10,
                previousMainColor: "#123456",
                position: 2,
                previousPosition: 1,
                positionDelta: -1,
                raceName: "Foo Grand Prix",
                raceFlag: "🏁",
                raceDate: Date(),
                year: 2022,
                round: 4
            )
        ])
        .frame(width: 1000, height: 300)
    }
}
