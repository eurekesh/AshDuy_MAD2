//
//  loader.swift
//  Lab2
//
//  Created by Ashlyn Duy on 1/31/22.
//

import Foundation

class Loader {
    var currData = [Category]()
    
    init(){
        load();
    }
    
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
    
    func getCategories() -> [String] {
        return currData.map( {$0.category })
    }
    
    func getGamesForCategory(_ cat: Int) -> [String] {
        return currData[cat].games.map( {$0.title} )
    }
    
    func deleteGame(_ idx: Int, _ idx2: Int) -> Void {
        currData[idx].games.remove(at: idx2)
    }
    
    func addGame(_ idx: Int, _ newGame: Release) -> Void {
        currData[idx].games.insert(newGame, at: currData[idx].games.count)
    }
    
    
    
}
