//
//  Armor.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/17/22.
//

import Foundation

struct Armor: Decodable {
    let itemHash: Int
    let name: String
    let type: String
    let `class`: String
    let mobility: Int
    let resilience: Int
    let recovery: Int
    let discipline: Int
    let intellect: Int
    let strength: Int
    let total: Int
}
