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
        get throws {
            try MySQL.shared.connect()
            return MySQL.shared.sql
        }
    }

    func execute(_ sql: SQLQueryString) throws -> [SQLRow] {
        try database.raw(sql).all().wait()
    }

    func execute<T: Decodable>(_ sql: SQLQueryString) throws -> [T] {
        try database.raw(sql).all(decoding: T.self).wait()
    }
}
