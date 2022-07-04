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
        return try await MySQL.shared.sql.raw(sql).all()
    }

    func execute<T: Decodable>(_ sql: SQLQueryString) async throws -> [T] {
        return try await MySQL.shared.sql.raw(sql).all(decoding: T.self)
    }
}
