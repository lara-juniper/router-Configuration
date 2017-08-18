//
//  TableViewController.swift
//  tableTesting2
//
//  Created by Lara Orlandic on 7/26/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController, dataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //connection.connect()
        //connection.sendDelegate = self //lets the connection send data to the view controller
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.checkConfiguredRouters))
        navigationItem.rightBarButtonItem = doneButton
        
        //Delete back button
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Junos Version for Each Router"
    }
    
    //MARK: Objects
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    
    var routers: [Router] = [Router(text: "R1"), Router(text: "R2"), Router(text: "R3"), Router(text: "R4"), Router(text: "R5"), Router(text: "R6"), Router(text: "R7"), Router(text: "R8"), Router(text: "R9"), Router(text: "R11"), Router(text: "R12"),Router(text: "R13"), Router(text: "R14")]
    
    var junosFiles: [String] = ["No Junos Files Found"]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routers.count
    }

    var cellArray: [PickerCell] = []
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as? PickerCell
            else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let router = routers[indexPath.row]
        cell.label.text = router.text
        cell.pickerElements = junosFiles
        cellArray.append(cell)


        return cell
    }
    
    
    //MARK: Functions
    var routerJunosDict = [String: String]()
    func checkConfiguredRouters() {
        routerJunosDict = generateDict()
        print(routerJunosDict)
        performSegue(withIdentifier: "Routers2Pwd", sender: nil)
    }
    
    //MARK: Custom Functions
    
    //function executes every time data flows from Python --> iPad
    func send(str: String) {
        processInputString(str: str)
    }
    

    var firstTime = true
    func processInputString(str: String) {
//        files = str.components(separatedBy: "\n")
//        if firstTime == true {
//            performSegue(withIdentifier: "RoutersToJunosFiles", sender: nil)
//            firstTime = false
//        }
    }
    
    //send message iPad --> Python
    func sendMessageToPython(str: String) {
        var arrayToServer: [UInt8] = [] //initialize array to be sent to server
        arrayToServer = Array(str.utf8)
        if connection.outputStream.hasSpaceAvailable { //If there is space available on the output stream (i.e. you're not sending too much data at once)
            let bytes = connection.outputStream.write(&arrayToServer, maxLength: arrayToServer.count) //write message to output stream
            print("\(bytes) bytes were sent to Python") //print how many bytes of data were sent
        } else { //error if you're trying to send too much data
            print("Error: no space available for writing")
        }
    }
    
    //Generate dictionary of Router:Version pairs
    func generateDict() -> [String: String] {
        var dict = [String: String]()
        for cell in cellArray {
            print("Cell exists: " + cell.label.text! + "\n")
            guard let junosVersion = cell.pickedElement else {
                continue
            }
            if junosVersion != "Disabled" {
                dict[cell.label.text!] = junosVersion
            }

        }
        return dict
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Routers2Pwd") {
            let secondViewController = segue.destination as! ViewController
            secondViewController.routerDict = routerJunosDict
            
        }
    }
    

}
