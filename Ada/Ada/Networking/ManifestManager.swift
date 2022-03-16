//
//  ManifestManager.swift
//  Ada
//
//  Created by Ashlyn Duy on 3/15/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class ManifestManager {
    let manifestUrl = "https://www.bungie.net/Platform/Destiny2/Manifest/"
    
//    let destination: DownloadRequest.Destination = { _, _ in
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentsURL.appendingPathComponent("d2_manifest.zip")
//
//        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//    }
    
    // generate API headers to retrieve manifest, thanks to Alamofire API docs!
    private func generateHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "X-API-KEY": "0697b20270f740c999f1c8ded766a5b9"
        ]
        
        return headers
    }
    
    func retrieveManifest(_ mods: [Mod], completion: @escaping ([ModManifestInfo], ManifestStatus) -> Void) -> Void {
        var modHashes: [String] = []
        for mod in mods {
            modHashes.append(mod.itemHash.description)
        }
        
         AF.request(manifestUrl, headers: generateHeaders())
            .responseData
        { [self] response in
            // debugPrint(response)
            
            switch response.result {
                case .success:
                    if let manifestData = response.data {
                        let json = try? JSON(data: manifestData)
                        if let search = json!["Response"]["jsonWorldComponentContentPaths"]["en"]["DestinyInventoryItemDefinition"].string {
                            digestManifest(search, modHashes) {
                                (digestedResults, status) in
                                completion(digestedResults, .success)
                            }
                        } else {
                            completion([], .failedDigestion)
                        }
                    }
                case .failure:
                    completion([], .overallFailure) // boolean indicates good/bad download
            }
        }
    }
    
    // function prototype inspired by https://stackoverflow.com/a/34121613
    private func digestManifest(_ jsonContentPath: String, _ hashes: [String], completion: @escaping ([ModManifestInfo], ManifestStatus) -> Void) -> Void {
        
        let urlString = "https://www.bungie.net/\(jsonContentPath)"
        var modManifestInfo: [ModManifestInfo] = []
        
        AF.request(urlString)
            .responseData
        {
            response in
            // debugPrint(response)
            switch response.result {
            case .success:
                if let d2items = response.data {
                    let json = try? JSON(data: d2items)
                    
                    for hash in hashes {
                        var iconUrl: String = ""
                        var modDescription: String = ""
                        if let icon = json?[hash]["displayProperties"]["icon"].string {
                            iconUrl = icon
                        }
                        
                        if let description = json?[hash]["tooltipNotifications"][0]["displayString"].string {
                            modDescription = description
                        }
                        
                        let newModManifest = ModManifestInfo(iconPath: iconUrl, modDescription: modDescription)
                        modManifestInfo.append(newModManifest)
                    }
                    completion(modManifestInfo, .success)
                }
            case .failure:
                print("Request for static manifest failed")
                completion([], .overallFailure)
            }
        }
    }
    
    
}
