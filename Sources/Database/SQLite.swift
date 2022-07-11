//
//  SQLite.swift
//
//
//  Created by Eneko Alonso on 4/14/22.
//

import Foundation
import GRDB

public final class SQLite {
    public var pool: DatabasePool

    public init(path: String) throws {
        pool = try DatabasePool(path: path)
    }
}
