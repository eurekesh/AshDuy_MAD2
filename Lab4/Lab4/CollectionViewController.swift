//
//  CollectionViewController.swift
//  Lab4
//
//  Created by Ashlyn Duy on 2/19/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for idx in 1...15 {
            images.append(idx.description)
        }
        
        collectionView.collectionViewLayout = generateLayout()
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetail" {
            let idxPath = collectionView?.indexPath(for: sender as! CollectionViewCell)
            let vc = segue.destination as! DetailViewController
            vc.image = images[(idxPath?.row)!]
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        let img = UIImage(named: images[indexPath.row])
        cell.cellImage.image = img
    
        return cell
    }
    
    // straight from notes, with added footer
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
       
        let photoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        photoItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
 
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: photoItem, count: 3)

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)

        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = CollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CollectionReusableView
            header.labelText.text = "Nature Photos"
        } else if kind == UICollectionView.elementKindSectionFooter {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! CollectionReusableView
            header.labelText.text = "That's all folks!"
        }
        return header
    }

}
