//
//  ModInventoryCollectionViewController.swift
//  Ada
//
//  Created by Ashlyn Duy on 3/16/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class ModInventoryCollectionViewController: UICollectionViewController {

    var mods = [Mod]()
    
    var modManifest = [ModManifestInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMods()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
