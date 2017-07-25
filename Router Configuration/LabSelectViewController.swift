//
//  LabSelectViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/19/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class LabSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lab2Button.isEnabled = false
        lab3Button.isEnabled = false
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Lab"
    }
    
    @IBOutlet weak var lab1Button: UIButton!
    
    @IBOutlet weak var lab2Button: UIButton!
    
    @IBOutlet weak var lab3Button: UIButton!
    
    
}
