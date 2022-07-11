//
//  CLI.swift
//  GrandPrixStatsCLI
//
//  Created by Eneko Alonso on 4/21/22.
//

import ArgumentParser
import Foundation

@main
struct CLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "gps",
        abstract: "Grand Prix Stats Command Line Tool",
        version: "1.0.0",
        subcommands: [
            Database.self,
            List.self,
            Load.self,
            Visualize.self
        ]
    )
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}

struct OutputOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output image width")
    var width: Int?
    @Option(name: .shortAndLong, help: "Output image height")
    var height: Int?
    @Option(name: .shortAndLong, help: "Output file path")
    var filePath = URL(fileURLWithPath: "test.png")
}

struct RaceOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Season year")
    var year: Int
    @Option(name: .shortAndLong, help: "Season round")
    var round: Int
}
