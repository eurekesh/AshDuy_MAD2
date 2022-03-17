//
//  ModDetailViewController.swift
//  Ada
//
//  Created by Ashlyn Duy on 3/16/22.
//

import UIKit

class ModDetailViewController: UIViewController {
    @IBOutlet weak var modDetailImage: UIImageView!
    
    @IBOutlet weak var modDetailsLabel: UILabel!
    
    var image: UIImage?
    var mod_description: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let img = image {
            modDetailImage.image = img
        }
        if let descrip = mod_description {
            modDetailsLabel.text = descrip
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
