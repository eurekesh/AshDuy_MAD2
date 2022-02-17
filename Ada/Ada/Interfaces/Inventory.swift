//
//  Inventory.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/17/22.
//

import Foundation

struct Inventory: Decodable {
    let armor: [Armor]
    let weapons: [Weapon]
    let mods: [Mod]
}
