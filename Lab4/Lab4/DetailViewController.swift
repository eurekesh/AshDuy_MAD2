//
//  DetailViewController.swift
//  Lab4
//
//  Created by Ashlyn Duy on 2/20/22.
//

import UIKit

class DetailViewController: UIViewController {
    var image: String?
    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        let screen = UIActivityViewController(activityItems: [imageDetail.image!], applicationActivities: nil)
        
        screen.modalPresentationStyle = .popover
        screen.popoverPresentationController?.barButtonItem = sender
        present(screen, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let img = image {
            imageDetail.image = UIImage(named: img)
        }
    }
}
