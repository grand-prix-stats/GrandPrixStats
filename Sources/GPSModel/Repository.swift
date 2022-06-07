//
//  Repository.swift
//  Database
//
//  Created by Eneko Alonso on 4/24/22.
//

import Foundation
import SQLKit
import Database

public class Repository {
    public init() {}

    func execute(_ sql: SQLQueryString) async throws -> [SQLRow] {
//        print(#function, Thread.isMainThread)
        return try await MySQL.shared.sql.raw(sql).all()
//        return try MySQL.shared.sql.raw(sql).all().wait()
    }

    func execute<T: Decodable>(_ sql: SQLQueryString) async throws -> [T] {
//        print(#function, Thread.isMainThread)
        return try await MySQL.shared.sql.raw(sql).all(decoding: T.self)
//        return try MySQL.shared.sql.raw(sql).all(decoding: T.self).wait()
    }
}
