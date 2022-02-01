//
//  ViewController.swift
//  Lab2
//
//  Created by Ashlyn Duy on 1/31/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var releases = [String]()
    var releaseDates = [Date]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return releases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return releases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setDateText(row);
    }
    
    private func setDateText(_ row: Int) {
        // help from https://stackoverflow.com/questions/35700281/date-format-in-swift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        releaseDateLabel.text="\(releases[row]) releases on \(dateFormatter.string(from: releaseDates[row]))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let loader = Loader()
        loader.load()
        releases = loader.getReleases()
        releaseDates = loader.getReleaseDates()
        setDateText(0)
    }


}

