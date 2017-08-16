//
//  ConfigReportViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/11/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class ConfigReportViewController: UITableViewController, dataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        connection.sendDelegate = self
        
        let doneButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.startOver))
        navigationItem.rightBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Tracking Installation Progress"
    }
    
    //MARK: Custom objects
    var routerDict = [String:String]()
    var messageVec = [String]()
    var connection = Connection()
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageVec.count
    }

/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath) as? ConfigCell
            else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let routerNames = [String](routerDict.keys)
        let router = routerNames[indexPath.row]
        cell.routerNumber.text = router
        cell.junosVersion.text = routerDict[router]
        
        
        return cell
    }
*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell! else {
            fatalError("The dequeued cell is not an instance of UITableViewCell.")
        }
        cell.textLabel?.text = messageVec[indexPath.row]
        
        return cell
    }
    
    //function executes every time data flows from Python --> iPad
    func send(str: String) {
        processInputString(str: str)
    }
    

    func processInputString(str: String) {
        let strVec = str.components(separatedBy: "\n")
        let strVec2 = strVec[0].components(separatedBy: ":")
        if strVec2[0] == "m" {
            messageVec.append(strVec2[1])
            tableView.reloadData()
        } else if strVec2[0] == "end" {
            messageVec.append(strVec2[1])
            tableView.reloadData()
            print(messageVec)
        }
        
    }
    
    func startOver() {
        performSegue(withIdentifier: "goHome", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
