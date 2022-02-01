//
//  ViewController.swift
//  Lab2
//
//  Created by Ashlyn Duy on 1/31/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    let categories = ["Video Games", "Board Games"]
    var activeReleases = [String]()
    var activeReleaseDates = [Date]()
    
    var vgReleases = [String]()
    var vgDates = [Date]()
    var boardReleases = [String]()
    var boardDates = [Date]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return categories.count
        } else {
            return activeReleases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return categories[row]
        }
        return activeReleases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            if (row == 0) {
                activeReleases = vgReleases
                activeReleaseDates = vgDates
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            } else {
                activeReleases = boardReleases
                activeReleaseDates = boardDates
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
            setDateText(0)
        }
        
        if (component == 1) {
            setDateText(row);
        }
    }
    
    private func setDateText(_ row: Int) {
        // help from https://stackoverflow.com/questions/35700281/date-format-in-swift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        releaseDateLabel.text="\(activeReleases[row]) releases on \(dateFormatter.string(from: activeReleaseDates[row]))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let loader = Loader()
        loader.load()
        vgReleases = Array(loader.getReleases().prefix(4))
        vgDates = Array(loader.getReleaseDates().prefix(4))
        boardReleases = Array(loader.getReleases().suffix(2))
        boardDates = Array(loader.getReleaseDates().suffix(2))
        activeReleases = vgReleases
        activeReleaseDates = vgDates
        setDateText(0)
    }


}

