//
//  StandingsView.swift
//  
//
//  Created by Eneko Alonso on 5/1/22.
//

import SwiftUI
import GPSEntities

struct StandingsRow: View {
    var standing: BeforeAndAfterStanding
    var size: CGSize
    var body: some View {
        HStack {
            OrdinalPosition(position: standing.position.ordinal, color: .gray)
                .frame(width: size.width * 0.1)
            ConstructorColoredLabel(
                constructorColor: standing.previousMainColor?.color ?? .clear,
                text: standing.previousName ?? "",
                subtext: standing.previousPoints?.formattedPoints ?? ""
            )
            .frame(width: size.width * 0.3)
            Spacer()
            ConstructorColoredLabel(
                constructorColor: standing.mainColor.color,
                text: standing.name,
                subtext: standing.points.formattedPoints
            )
            .frame(width: size.width * 0.3)
            OrdinalPosition(position: standing.position.ordinal, color: .gray)
                .frame(width: size.width * 0.1)
        }
        .frame(height: size.height)
    }
}

struct TitleView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Text(title)
                .font(.conthrax(22))
                .fixedSize()
            Text(subtitle)
                .font(.goodTiming(64))
                .multilineTextAlignment(.center)
                .fixedSize()
        }
    }
}

struct Title2View: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Text(title)
                .font(.goodTiming(64))
                .fixedSize()
            Text(subtitle)
                .font(.conthrax(32))
                .multilineTextAlignment(.center)
                .fixedSize()
        }
    }
}

public struct StandingsView: View, Visualization {
    public static let defaultSize: CGSize = .init(width: 1200, height: 1800)
    
    public init(title: String, standings: [BeforeAndAfterStanding]) {
        self.title = title
        self.standings = standings
        self.standingPaths = standings.compactMap {
            guard let lastPosition = $0.lastPosition else {
                return nil
            }
            return StandingPath(
                identifier: $0.identifier,
                position: $0.position,
                lastPosition: lastPosition,
                mainColor: $0.mainColor
            )
        }
    }
    
    let title: String
    let standings: [BeforeAndAfterStanding]
    let standingPaths: [StandingPath]
    let spacing = 10.0

    struct StandingPath {
        let identifier: String
        let position: Int
        let lastPosition: Int
        let mainColor: String
    }

    public var body: some View {
        VStack {
            let race = standings.first?.raceName ?? "[RACE]"
            let year = standings.first.flatMap { String($0.year) } ?? ""
            TitleView(title: title, subtitle: "\(year) \(race)")

            GeometryReader { geometry in
                let rowHeight = (geometry.size.height / CGFloat(standings.count))
                let columnWidth = geometry.size.width * 0.1
                ZStack {
                    ForEach(standingPaths, id: \.identifier) { standing in
                        let x1 = geometry.size.width * 0.5 - columnWidth
                        let y1 = rowHeight * (CGFloat(standing.lastPosition) - 0.5)
                        let x2 = geometry.size.width * 0.5 + columnWidth
                        let y2 = rowHeight * (CGFloat(standing.position) - 0.5)

                        Path { path in
                            path.move(to: CGPoint(x: x1, y: y1))
                            path.addLine(to: CGPoint(x: x1 + columnWidth * 0.3, y: y1))
                            path.addLine(to: CGPoint(x: x2 - columnWidth * 0.3, y: y2))
                            path.addLine(to: CGPoint(x: x2, y: y2))
                        }
                        .strokedPath(.init(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(standing.mainColor.color)
                    }
                    
                    VStack(spacing: spacing) {
                        ForEach(standings, id: \.identifier) { standing in
                            StandingsRow(standing: standing, size: CGSize(width: geometry.size.width, height: rowHeight - spacing))
                        }
                    }
                }
            }
        }
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsView(
            title: "Driver Standings before and after",
            standings: [
                DriverStanding(
                    driverRef: "foo",
                    surname: "Foo",
                    code: "FOO",
                    permanentNumber: 22,
                    points: 22,
                    mainColor: "#123456",
                    position: 1,
                    lastPosition: 2,
                    positionDelta: 1,
                    previousDriverRef: "bar",
                    previousSurname: "Bar",
                    previousCode: "BAR",
                    previousPermanentNumber: 33,
                    previousPoints: 18,
                    previousMainColor: "#234567",
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
                    position: 2,
                    lastPosition: 1,
                    positionDelta: -1,
                    previousDriverRef: "foo",
                    previousSurname: "Foo",
                    previousCode: "FOO",
                    previousPermanentNumber: 22,
                    previousPoints: 10,
                    previousMainColor: "#123456",
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

public protocol BeforeAndAfterStanding {
    var identifier: String { get }
    var name: String { get }
    var points: Double { get }
    var mainColor: String { get }
    var position: Int { get }
    var lastPosition: Int? { get }
    var previousName: String? { get }
    var previousPoints: Double? { get }
    var previousMainColor: String? { get }
    var raceName: String { get }
    var year: Int { get }
}

extension DriverStanding: BeforeAndAfterStanding {
    public var identifier: String {
        driverRef
    }
    
    public var name: String {
        code
    }
    
    public var previousName: String? {
        previousCode
    }
}

extension ConstructorStanding: BeforeAndAfterStanding {
    public var identifier: String {
        constructorRef
    }
}
