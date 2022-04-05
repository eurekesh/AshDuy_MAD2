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
    let contentManifestUrl = "contentPathManifest.json"
    let modManifestUrl = "itemManifest.json"
    
    var contentManifestFileExist = false
    var modManifestFileExists = false
    
    init(){
        checkLocalManifestExistence()
    }
    
    private func checkLocalManifestExistence() -> Void {
        // first check if content manifest file exists, this file gives location of item manifest
        // help from https://stackoverflow.com/a/41426747
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let contentDocPath = documentsDir.appendingPathComponent(contentManifestUrl)
            let modManifestDocPath = documentsDir.appendingPathComponent(modManifestUrl)
            
            if(FileManager.default.fileExists(atPath: contentDocPath.path)) {
                contentManifestFileExist = true
            }
            
            if(FileManager.default.fileExists(atPath: modManifestDocPath.path)) {
                modManifestFileExists = true
            }
        }
    }
    
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
        
        if contentManifestFileExist {
            if let search = digestPathManifest(readDownloadedData(contentManifestUrl)!) {
                fetchModManifest(search, modHashes) {
                    (digestedResults, status) in
                    completion(digestedResults, .success)
                }
            } else {
                completion([], .failedDigestion)
            }
        }
        
        
         AF.request(manifestUrl, headers: generateHeaders())
            .responseData
        { [self] response in
            // debugPrint(response)
            
            switch response.result {
                case .success:
                    if let manifestData = response.data {
                        
                        if let search = digestPathManifest(manifestData) {
                            fetchModManifest(search, modHashes) {
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
    
    private func digestPathManifest(_ dat: Data) -> String? {
        let json = try? JSON(data: dat)
        if let search = json!["Response"]["jsonWorldComponentContentPaths"]["en"]["DestinyInventoryItemDefinition"].string {
            return search
        }
        return nil
    }
    
    // function prototype inspired by https://stackoverflow.com/a/34121613
    private func fetchModManifest(_ jsonContentPath: String, _ hashes: [String], completion: @escaping ([ModManifestInfo], ManifestStatus) -> Void) -> Void {
        
        if modManifestFileExists {
            print("Cached mod manifest is being used")
            if let file_data = readDownloadedData(modManifestUrl) {
                completion(digestModManifest(file_data, hashes), .success)
                return
            }
        }
        
        let urlString = "https://www.bungie.net/\(jsonContentPath)"
        var modManifestInfo: [ModManifestInfo] = []
        
        AF.request(urlString)
            .responseData
        { [self]
            response in
            // debugPrint(response)
            switch response.result {
            case .success:
                if let d2items = response.data {
                    saveDownloadedData(d2items, modManifestUrl)
                    modManifestFileExists = true
                    modManifestInfo = digestModManifest(d2items, hashes)
                    completion(modManifestInfo, .success)
                }
            case .failure:
                print("Request for static manifest failed")
                completion([], .overallFailure)
            }
        }
    }
    
    // seperate out parsing logic so it can operate on file or download
    private func digestModManifest(_ d2items: Data, _ hashes: [String]) -> [ModManifestInfo] {
        let json = try? JSON(data: d2items)
        var modManifestInfo: [ModManifestInfo] = []
        
        for hash in hashes {
            var iconUrl: String = ""
            var modDescription: String = ""
            if let icon = json?[hash]["displayProperties"]["icon"].string {
                iconUrl = icon
            }
            
            if let description = json?[hash]["tooltipNotifications"][0]["displayString"].string {
                modDescription = description
            }
            
            let newModManifest = ModManifestInfo(iconPath: "https://www.bungie.net\(iconUrl)", modDescription: modDescription)
            modManifestInfo.append(newModManifest)
        }
        return modManifestInfo
    }
    
    private func saveDownloadedData(_ dat: Data, _ url: String) -> Void {
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let savePath = documentsDir.appendingPathComponent(url)
            
            do {
                try dat.write(to: savePath)
                print("Successfully saved \(url) file to device")
            } catch {
                print("Could not save \(url) correctly")
            }
        }
    }
    
    // inspired from https://stackoverflow.com/a/41426747
    private func readDownloadedData(_ url: String) -> Data? {
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let savePath = documentsDir.appendingPathComponent(url)
            
            do {
                let dat = try Data(contentsOf: savePath, options: .alwaysMapped)
                print("cached version of \(url) is being used")
                return dat
            } catch {
                print("\(url) could not be properly retrieved from cache")
            }
        }
        
        return nil
    }
    
}
