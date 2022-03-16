//
//  ViewController.swift
//  Ada
//
//  Created by Ashlyn Duy on 2/16/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var modLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var mods = [Mod]()
    
    var modManifest = [ModManifestInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMods()
    }
    
    func loadMods() -> Void {
        let nwManager = NetworkManager()
        Task {
            loadingSpinner.startAnimating()
            loadingSpinner.isHidden = false
            async let newMods = nwManager.getMods()
            mods = await newMods
            loadingSpinner.stopAnimating()
            loadingSpinner.isHidden = true
            loadModInfo()
            await retrieveManifest()
            modLabel.isHidden = false
        }
    }
    
    func loadModInfo() -> Void {
        if mods.isEmpty {
            modLabel.text = "Destiny API is offline"
            return
        }
        var modTest = ""
        for mod in mods {
            let currModTitle = mod.name
            let currModType = mod.type
            let currTest = "The \(currModTitle) mod of type \(currModType) is being sold for 10 mod components \n \n"
            modTest.append(currTest)
        }
        
        modLabel.text = modTest
        
        
    }
    
    func retrieveManifest() async {
        let manifestManager = ManifestManager()
        print("Calling retrieve manifest")
        manifestManager.retrieveManifest(mods) { [self]
            (data, status) in
            
            switch status {
            case .success:
                modManifest = data
                print("Successfully retrieved mod manifest data")
            case .failedDigestion:
                print("Something went wrong with static manifest digestion")
            case .overallFailure:
                print("Manifest could not be downloaded")
            }
        }
    }
}
