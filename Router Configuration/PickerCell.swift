//
//  PickerCell.swift
//  tableTesting2
//
//  Created by Lara Orlandic on 7/26/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.picker.delegate = self
        self.picker.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: Outlets
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    //MARK: Custom Objects
    
    var pickerElements: [String] = ["junos 1", "junos 2", "junos 3", "junos 4"]
    var pickedElement: String? = nil
    
    //MARK: Picker View Data Source and delegate functions
    
    //Number of sub-pickers in picker. 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Select number of options in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElements.count
    }
    
    //Establish data in pickers
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElements[row]
    }
    
    //Run every time picker selects a pickerElement
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedElement = pickerElements[row]
    }
    
}
