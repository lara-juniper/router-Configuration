//
//  RouterCommandSelectViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/18/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class RouterCommandSelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        routerPicker.delegate = self
        routerPicker.dataSource = self
        commandPicker.dataSource = self
        commandPicker.delegate = self
        
        
        routerPicker.tag = 1
        commandPicker.tag = 2
        
        selectedRouter = routers[0].text
        selectedCommand = commands[0]
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nextScreen))
        navigationItem.rightBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Router and Command"
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var routerPicker: UIPickerView!
    @IBOutlet weak var commandPicker: UIPickerView!

    
    //MARK: Custom objects
    
    let routers: [Router] = [Router(text: "R1"), Router(text: "R2"), Router(text: "R3"), Router(text: "R4"), Router(text: "R5"), Router(text: "R6"), Router(text: "R7"), Router(text: "R8"), Router(text: "R9"), Router(text: "R11"), Router(text: "R12"),Router(text: "R13"), Router(text: "R14")]
    let commands: [String] = ["Show Version", "Show Chassis Hardware", "Show Chassis Routing Engine"]
    var selectedRouter = ""
    var selectedCommand = ""
    
    //MARK: Functions
    func nextScreen() {
        performSegue(withIdentifier: "routerCommandToLogin", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Picker View Data Source and delegate functions
    
    //Number of sub-pickers in picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Select number of options in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return routers.count
        } else {
            return commands.count
        }
    }
    
    //Establish data in pickers
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return routers[row].text
        } else {
            return commands[row]
        }
    }
    
    //Run every time picker selects a pickerElement
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedRouter = routers[row].text
        } else {
            selectedCommand = commands[row]
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "routerCommandToLogin") {
            let secondViewController = segue.destination as! ViewController
            secondViewController.selectedRouter = selectedRouter
            secondViewController.command = selectedCommand
            
        }
    }

}
