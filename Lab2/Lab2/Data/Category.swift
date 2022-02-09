//
//  Category.swift
//  Lab3
//
//  Created by Ashlyn Duy on 2/8/22.
//

import Foundation

struct Category: Decodable {
    let category : String
    let release : [Release]
}
