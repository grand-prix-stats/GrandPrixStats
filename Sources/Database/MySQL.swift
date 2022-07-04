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
    var logger = Logger(label: "org.grandprixstats")
    logger.logLevel = Logger.Level.info
    return logger
}()

public final class MySQL {
    public static let shared = MySQL()
    let env = DotEnv(withFile: ".env")
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var eventLoopGroup: EventLoopGroup!
    var pool: EventLoopGroupConnectionPool<MySQLConnectionSource>!

    init() {
        encoder.dateEncodingStrategy = .secondsSince1970
        decoder.dateDecodingStrategy = .secondsSince1970

        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 10)

        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
        let configuration = MySQLConfiguration(
            hostname: env.get("DB_HOST") ?? "localhost",
            port: env.getAsInt("DB_PORT") ?? 3306,
            username: env.get("DB_USER") ?? "",
            password: env.get("DB_PASS") ?? "",
            database: env.get("DB_NAME") ?? "",
            tlsConfiguration: tls
        )
        pool = EventLoopGroupConnectionPool(
            source: MySQLConnectionSource(configuration: configuration),
            maxConnectionsPerEventLoop: 1,
            requestTimeout: .seconds(30),
            logger: logger,
            on: eventLoopGroup
        )
    }

    public var db: MySQLDatabase {
        pool.database(logger: logger)
    }

    public var sql: SQLDatabase {
        db.sql(encoder: .init(json: encoder), decoder: .init(json: decoder))
    }
}
