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
    
    var dataRetrievalComplete = false
    
    var modImageDict: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        loadMods()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        super.viewDidAppear(true)
//
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMod" {
            let cell = sender as! ModCellCollectionViewCell
            let path = collectionView?.indexPath(for: cell)
            let modVC = segue.destination as! ModDetailViewController
            modVC.image = cell.cellImage.image
            modVC.mod_description = modManifest[path!.row].modDescription
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataRetrievalComplete == false ? 0 : 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataRetrievalComplete == false ? 0 : 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ModCellCollectionViewCell
        
        guard dataRetrievalComplete else {
            return cell
        }
        
        var index = indexPath.item
        if indexPath.section == 1 {
            index += 4
        }
        
        guard let url = URL(string: modManifest[index].iconPath) else { return cell }
        if let imgData = try? Data(contentsOf: url) {
            let cellImg = UIImage(data: imgData)
            cell.cellImage.image = cellImg
            modImageDict[modManifest[index].iconPath] = cellImg
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = HeaderSupplementaryView()
        
        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderSupplementaryView
            header.headerLabel.text = indexPath.section == 0 ? "Ada-1" : "Banshee-44"
        }
        return header
    }
    
    func loadMods() -> Void {
        let nwManager = NetworkManager()
        Task {
//            loadingSpinner.startAnimating()
//            loadingSpinner.isHidden = false
            async let newMods = nwManager.getMods()
            mods = await newMods
//            loadingSpinner.stopAnimating()
//            loadingSpinner.isHidden = true
            loadModInfo()
            await retrieveManifest()

//            modLabel.isHidden = false
        }
    }
    
    func loadModInfo() -> Void {
//        if mods.isEmpty {
//            modLabel.text = "Destiny API is offline"
//            return
//        }
//        var modTest = ""
//        for mod in mods {
//            let currModTitle = mod.name
//            let currModType = mod.type
//            let currTest = "The \(currModTitle) mod of type \(currModType) is being sold for 10 mod components \n \n"
//            modTest.append(currTest)
//        }
//
//        modLabel.text = modTest
        
        
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
                dataRetrievalComplete = true
                collectionView.reloadData()
            case .failedDigestion:
                print("Something went wrong with static manifest digestion")
            case .overallFailure:
                print("Manifest could not be downloaded")
            }
        }
    }
    
    // based off of https://medium.com/codex/cagradientlayer-tutorial-how-to-create-a-gradient-with-swift-5-2817a393dad
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.cyan.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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
