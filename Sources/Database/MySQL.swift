//
//  Database.swift
//  APIGenerator
//
//  Created by Eneko Alonso on 1/26/19.
//

import Foundation
import MySQLKit
import DotEnv

let logger: Logger = {
    var logger = Logger(label: "com.enekoalonso.mysql2sqlite")
    logger.logLevel = .debug
    return logger
}()

final class MySQL {
    public static let shared = MySQL()
    let env = DotEnv(withFile: ".env")
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var eventLoopGroup: EventLoopGroup!
    var pools: EventLoopGroupConnectionPool<MySQLConnectionSource>!

    init() {
        encoder.dateEncodingStrategy = .secondsSince1970
        decoder.dateDecodingStrategy = .secondsSince1970
    }

    var sql: SQLDatabase {
        db.sql(encoder: .init(json: encoder), decoder: .init(json: decoder))
    }

    var db: MySQLDatabase {
        pools.database(logger: logger)
    }

    func connect() throws {
        guard pools == nil else {
            return
        }

        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let configuration = MySQLConfiguration(
            hostname: env.get("DB_HOST") ?? "localhost",
            port: env.getAsInt("DB_PORT") ?? 3306,
            username: env.get("DB_USER") ?? "",
            password: env.get("DB_PASS") ?? "",
            database: env.get("DB_NAME") ?? "",
            tlsConfiguration: tls
        )
        pools = .init(
            source: .init(configuration: configuration),
            maxConnectionsPerEventLoop: 2,
            requestTimeout: .seconds(30),
            logger: logger,
            on: eventLoopGroup
        )
    }
}
