//
//  ViewController.swift
//  Lab3
//
//  Created by Ashlyn Duy on 2/8/22.
//

import UIKit

class AddGameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var releaseTime: UIDatePicker!
    @IBOutlet weak var gameName: UITextField!
    
    var addGame = String()
    var addDate = Date()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done" {
            if gameName.text?.isEmpty == false {
                addGame = gameName.text!
                addDate = releaseTime.date
        }
    }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        gameName.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(obliterateKeyboard)))
        // Do any additional setup after loading the view.
    }
    
    // from lab 4 of last semester :D
    @objc func obliterateKeyboard() {
        view.endEditing(true)
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
