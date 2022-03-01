//
//  NetworkManager.swift
//  Lab5
//
//  Created by Ashlyn Duy on 2/27/22.
//

import Foundation

struct Response : Decodable {
    let message: URL?
    let status: String?
}

class NetworkManager {
    func sendRequest(_ url: String) async -> Response {
        guard let urlPath = URL(string: url)
        else {
            print("Could not parse URL")
            return Response(message: nil, status: nil)
        }
        
        do {
            let (dat, res) = try await URLSession.shared.data(from: urlPath, delegate: nil)
            guard (res as? HTTPURLResponse)?.statusCode == 200
            else {
                print("Error retrieving data")
                return Response(message: nil, status: nil)
            }
            
            print("successful retrieval")
            print(dat)
            let parsedResponse = parse(dat)
            return parsedResponse
        }
        catch {
            print(error.localizedDescription)
            return Response(message: nil, status: nil)
        }
    }
    
    func parse(_ dat: Data) -> Response {
        do {
            let responseDat = try JSONDecoder().decode(Response.self, from: dat)
            return responseDat
        } catch let err {
            print(err.localizedDescription)
            return Response(message: nil, status: nil)
        }
    }
    
    func getDogImage() async -> URL {
        let endpoint = "https://dog.ceo/api/breeds/image/random/"
        async let res = sendRequest(endpoint)
        return await res.message ?? URL(string: "https://images.dog.ceo/breeds/komondor/n02105505_4458.jpg")! // default dog picture
    }
}


