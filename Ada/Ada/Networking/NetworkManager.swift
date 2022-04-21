//
//  NetworkManager.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/16/22.
//

import Foundation

class NetworkManager {
    var mods = [Mod]()
    let userDefaults = UserDefaults.standard
    
    func sendRequest(_ url: String) async -> Response {
        guard let urlPath = URL(string: url)
        else {
            print("Could not parse URL")
            return Response(inventory: nil, metadata: nil)
        }
        
        do {
            let (dat, res) = try await URLSession.shared.data(from: urlPath, delegate: nil)
            guard (res as? HTTPURLResponse)?.statusCode == 200
            else {
                print("Error retrieving data")
                return Response(inventory: nil, metadata: nil)
            }
            
            print("successful retrieval")
            print(dat)
            let parsedResponse = parse(dat)
            return parsedResponse
        }
        catch {
            print(error.localizedDescription)
            return Response(inventory: nil, metadata: nil)
        }
    }
    
    func parse(_ dat: Data) -> Response {
        do {
            let responseDat = try JSONDecoder().decode(Response.self, from: dat)
            return responseDat
        } catch let err {
            print(err)
            return Response(inventory: nil, metadata: nil)
        }

    }
    
    func getMods() async -> [Mod] {
        if let check_mods = modCheckNeeded() {
            return check_mods
        }
        
        async let ada_mods = sendRequest("https://api.destinyinsights.com/ada-1")
        async let banshee_mods = sendRequest("https://api.destinyinsights.com/banshee-44")
        // first 4 mods are always ada's, next 4 are always banshee's
        let responses = await [ada_mods, banshee_mods]
        
        for res in responses {
            if let modsEntry = res.inventory?.mods {
                mods.append(contentsOf: modsEntry)
            }
        }
        if let encoded = try? JSONEncoder().encode(mods) {
            userDefaults.set(encoded, forKey: "cachedMods")
        }
        
        return mods
    }
    
    private func modCheckNeeded() -> [Mod]? {
        let now = Date()
        let reset_time = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
        let yesterday_reset = Calendar.current.date(byAdding: .day, value: -1, to: reset_time)!
        let saved_reset_time = userDefaults.object(forKey: "lastRetrievalTime") as? Date ?? yesterday_reset
        
        if now.timeIntervalSince(yesterday_reset) > 86400 && now.timeIntervalSince(saved_reset_time) > 86400 {
            userDefaults.set(Date(), forKey: "lastRetrievalTime")
            print("new mod retrival needed")
            return nil
        }
        
        // had to rely on https://stackoverflow.com/a/59725805 for putting array of custom objs in userdefaults
        do {
            if let storedObjItem = UserDefaults.standard.object(forKey: "cachedMods") {
                let storedItems = try JSONDecoder().decode([Mod].self, from: storedObjItem as! Data)
                print("cached mods retrieved successfully")
                return storedItems
            }
            throw NetworkError.DecodeFailed // did not decode correctly
            
        } catch let err {
            print("no cached mods retrieved")
            print(err)
        }
        return nil
    }
}
