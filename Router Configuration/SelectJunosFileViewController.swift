//
//  SelectJunosFileViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/25/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class SelectJunosFileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = 50.0
        tableView.allowsMultipleSelection = true
        
        let doneButton = UIBarButtonItem(title: "Upgrade", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Junos Version"
    }
    
    var files: [String] = []
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: TableView Delegate/Datasource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath as IndexPath)
        let file = files[indexPath.row]
        cell.textLabel?.text = file
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        let file = files[indexPath.row]
        //do something when file selected
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        let file = files[indexPath.row]
        //do something when file unclicked
    }

    
}
