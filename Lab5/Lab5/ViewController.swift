//
//  ViewController.swift
//  Lab5
//
//  Created by Ashlyn Duy on 2/27/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func imageButton(_ sender: UIButton) {
        displayDog()
    }
    @IBOutlet weak var imageView: UIImageView!
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDog()
    }
    
    
    func displayDog() -> Void {
        Task {
            // hide/show important things
            imageView.isHidden = true
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            
            let dogUrl = await networkManager.getDogImage()
            // help below from https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift
            if let imageData = try? Data(contentsOf: dogUrl) {
                imageView.image = UIImage(data: imageData)
            }
            
            // once image data is set, we are ready to show!
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.isHidden = false
        }
    }
    
    


}

