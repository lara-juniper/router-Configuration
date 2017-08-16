//
//  SelectActionViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/19/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class SelectActionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        operationButton.isEnabled = false
        showConfigButton.isEnabled = false
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Option"
    }
    
    @IBAction func upgradeVersionButtonPress(_ sender: Any) {
        
        performSegue(withIdentifier: "ActionToTCP", sender: nil)
    }
    
    
    
    //MARK: Outlets

    @IBOutlet weak var upgradeButton: UIButton!
    
    @IBOutlet weak var operationButton: UIButton!
    
    @IBOutlet weak var showConfigButton: UIButton!
    
    
}
