//
//  loader.swift
//  Lab2
//
//  Created by Ashlyn Duy on 1/31/22.
//

import Foundation

class Loader {
    var currData = [Category]()
    
    func load() {
        let file = "releases"
        if let url = Bundle.main.url(forResource: file, withExtension: "plist") {
            let decoder = PropertyListDecoder()
            
            do {
                let dat = try Data(contentsOf: url)
                currData = try decoder.decode([Category].self, from: dat)
                print("success")
            } catch {
                print(error)
                print("Data could not be loaded")
            }
        }
    }
    
}
