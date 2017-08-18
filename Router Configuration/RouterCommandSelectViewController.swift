//
//  RouterCommandSelectViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/18/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class RouterCommandSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var routerPicker: UIPickerView!
    @IBOutlet weak var commandPicker: UIPickerView!

    
    //MARK: Custom objects
    
    let routers: [Router] = [Router(text: "R1"), Router(text: "R2"), Router(text: "R3"), Router(text: "R4"), Router(text: "R5"), Router(text: "R6"), Router(text: "R7"), Router(text: "R8"), Router(text: "R9"), Router(text: "R11"), Router(text: "R12"),Router(text: "R13"), Router(text: "R14")]
    let commands: [String] = ["Show Version", "Show Chassis Hardware", "Show Chassis Routing Engine"]
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
