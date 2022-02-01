//
//  OpenAppViewController.swift
//  Lab2
//
//  Created by Ashlyn Duy on 1/31/22.
//

import UIKit

class OpenAppViewController: UIViewController {

    
    
    
    
    @IBAction func buttonClicked(_ sender: Any) { if(UIApplication.shared.canOpenURL(URL(string: "calshow://")!)){
            //open the app with this URL scheme
            UIApplication.shared.open(URL(string: "calshow://")!, options: [:], completionHandler: nil)
    } else {
        let message = UIAlertController(title: "Uh oh!", message: "Apple calendar is not installed, please install it!", preferredStyle: .alert);
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil);
        message.addAction(okAction);
        present(message, animated: true, completion: nil)
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
