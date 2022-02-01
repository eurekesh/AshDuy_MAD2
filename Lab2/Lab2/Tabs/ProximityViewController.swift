//
//  ProximityViewController.swift
//  Lab2
//
//  Created by Ashlyn Duy on 1/31/22.
//

import UIKit

class ProximityViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        // some date help from https://stackoverflow.com/questions/40075850/swift-3-find-number-of-calendar-days-between-two-dates
        if let days = Calendar.current.dateComponents([.day], from: Date(), to: sender.date).day {
            dateLabel.text = "It's only \(days) days away!"
            if days == 0 {
                dateLabel.text = "Today's the day!"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = "Today's the day!"
        // Do any additional setup after loading the view.
    }

}
