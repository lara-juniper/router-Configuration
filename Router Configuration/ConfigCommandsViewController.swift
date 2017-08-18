//
//  ConfigCommandsViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/17/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class ConfigCommandsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Command"
    }
    
    //MARK: Custom Objects
    
    var selectedRouter: String = ""
    var command: String = ""
    
    @IBAction func showVersionPress(_ sender: Any) {
        command = "version"
        performSegue(withIdentifier: "configCommandsToReport", sender: nil)
    }

    @IBAction func showChassisHWPress(_ sender: Any) {
        command = "chassisHW"
        performSegue(withIdentifier: "configCommandsToReport", sender: nil)
    }
    
    @IBAction func showChassisREPress(_ sender: Any) {
        command = "chassisRE"
        performSegue(withIdentifier: "configCommandsToReport", sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "configCommandsToReport") {
            let secondViewController = segue.destination as! ShowConfigReportViewController
            secondViewController.selectedRouter = selectedRouter
            secondViewController.messageToPython = command
        }
    }
    

}
