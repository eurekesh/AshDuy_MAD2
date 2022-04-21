//
//  ModInventoryCollectionViewController.swift
//  Ada
//
//  Created by Ashlyn Duy on 3/16/22.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

private let reuseIdentifier = "Cell"

class ModInventoryCollectionViewController: UICollectionViewController {

    var mods = [Mod]()
    
    var modManifest = [ModManifestInfo]()
    
    var dataRetrievalComplete = false
    
    var modImageDict: [String:UIImage] = [:]
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect())
    
    @IBOutlet weak var loadingIcon: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let frame = CGRect(x: collectionView.center.x-22.5, y: collectionView.center.y-22.5, width:45, height: 45)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple)
        
        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadMods()
        
        collectionView.collectionViewLayout = generateLayout()
        
        // thanks to https://stackoverflow.com/a/44323459 !
        // background source is https://wallpapercave.com/w/wp5081461
        let background: UIImageView = {
            let imgv = UIImageView()
            imgv.image = UIImage(named:"d2-background")
            imgv.contentMode = .scaleAspectFill
            return imgv
        }()
        
        self.collectionView.backgroundView = background
        
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
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url)
        
        cell.modDescription.text = modManifest[index].modDescription
        cell.modTitle.text = mods[index].name
        cell.modType.text = mods[index].type

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = HeaderSupplementaryView()
        
        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderSupplementaryView
            header.headerLabel.text = indexPath.section == 0 ? "Ada-1" : "Banshee-44"
            header.vendorImage.image = indexPath.section == 0 ? UIImage(named: "ada") : UIImage(named: "banshee")
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
            await retrieveManifest()
//            modLabel.isHidden = false
        }
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
                loadingIndicator.stopAnimating()
                collectionView.reloadData()
            case .failedDigestion:
                print("Something went wrong with static manifest digestion")
            case .overallFailure:
                print("Manifest could not be downloaded")
            }
        }
    }

    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
       
        let modItem = NSCollectionLayoutItem(layoutSize: itemSize)
        modItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
 
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: modItem, count: 1)

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        sectionHeader.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [sectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
