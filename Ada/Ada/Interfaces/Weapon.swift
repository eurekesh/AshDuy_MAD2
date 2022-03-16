//
//  Weapon.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/17/22.
//

import Foundation

struct Weapon: Decodable {
    let itemHash: Int
    let name: String
    let type: String
    let perks: [String]
    let wishList: Bool?
}
