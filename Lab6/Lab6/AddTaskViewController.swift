//
//  ViewController.swift
//  Lab6
//
//  Created by Ashlyn Duy on 3/24/22.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var completeByField: UIDatePicker!
    
    var outTaskName = String()
    var outCompleteDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savesegue" {
            if taskNameField.text?.isEmpty == false {
                outTaskName = taskNameField.text!
                outCompleteDate = completeByField.date
            }
        }
    }


}

// from https://stackoverflow.com/a/47302516
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

