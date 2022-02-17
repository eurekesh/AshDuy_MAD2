//
//  NetworkManager.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/16/22.
//

import Foundation

class NetworkManager {
    var mods = [Mod]()
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
                print("Could not locate file")
                return Response(inventory: nil, metadata: nil)
            }
            
            print("successful retrieval")
            print(dat)
            let parsedResponse = parse(dat)
            return parsedResponse
        }
        catch {
            print(error.localizedDescription)
        }
        return Response(inventory: nil, metadata: nil)
    }
    
    func parse(_ dat: Data) -> Response {
        do {
            let responseDat = try JSONDecoder().decode(Response.self, from: dat)
            return responseDat
        } catch let err {
            print(err.localizedDescription)
        }
        return Response(inventory: nil, metadata: nil)
    }
    
    func getMods() async -> [Mod] {
        async let ada_mods = sendRequest("https://api.destinyinsights.com/ada-1")
        async let banshee_mods = sendRequest("https://api.destinyinsights.com/banshee-44")
        let responses = await [ada_mods, banshee_mods]
    
        for res in responses {
            if let modsEntry = res.inventory?.mods {
                mods.append(contentsOf: modsEntry)
            }
        }
        return mods
    }
}
