//
//  Repository.swift
//  Database
//
//  Created by Eneko Alonso on 4/24/22.
//

import Foundation
import SQLKit

public class Repository {
    public init() {}

    var database: SQLDatabase {
        MySQL.shared.sql
    }

    func execute(_ sql: SQLQueryString) async throws -> [SQLRow] {
        try await database.raw(sql).all()
    }

    func execute<T: Decodable>(_ sql: SQLQueryString) async throws -> [T] {
        print(#function, sql)
        return try await database.raw(sql).all(decoding: T.self)
    }
}
