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

    func execute(_ sql: SQLQueryString, caller: String = #function) async throws -> [SQLRow] {
        do {
            return try await MySQL.shared.sql.raw(sql).all()
        } catch {
            print("[ERROR] Failed to execute SQL statement (\(caller))")
            print(sql)
            throw error
        }
    }

    func execute<T: Decodable>(_ sql: SQLQueryString, caller: String = #function) async throws -> [T] {
        do {
            return try await MySQL.shared.sql.raw(sql).all(decoding: T.self)
        } catch {
            print("[ERROR] Failed to execute SQL statement (\(caller))")
            print(sql)
            throw error
        }
    }
}
