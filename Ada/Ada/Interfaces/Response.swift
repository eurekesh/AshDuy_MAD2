//
//  Response.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/16/22.
//

import Foundation

struct Response: Decodable {
    let inventory: Inventory?
    let metadata: MetaData?
}

struct MetaData: Decodable {
    let name: String
    let now: String
    let usedCacheAuth: Bool
    let usedCachedData: Bool
}
