//
//  SelectRoutersViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/19/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit


class SelectRoutersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, dataDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = 50.0
        tableView.allowsMultipleSelection = true
        
        connection.connect() //connect socket
        connection.sendDelegate = self //lets the connection send data to the view controller
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.checkConfiguredRouters))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Routers to Configure"
    }
    
    //MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    
    //MARK: Objects
    
    var routers: [Router] = [Router(text: "R1"), Router(text: "R2"), Router(text: "R3"), Router(text: "R4"), Router(text: "R5"), Router(text: "R6"), Router(text: "R7"), Router(text: "R8"), Router(text: "R9"), Router(text: "R11"), Router(text: "R12"),Router(text: "R13"), Router(text: "R14")]
    
    //MARK: Functions
    func checkConfiguredRouters() {
        var routerString = ""
        for router in routers {
            if router.clicked {
                routerString = routerString + router.text + "\n"
                print(router.text + "\n")
            }
        }
        sendMessageToPython(str: routerString)
    }
    
    
    
    //MARK: TableView Delegate/Datasource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath as IndexPath) 
        let router = routers[indexPath.row]
        cell.textLabel?.text = router.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        let router = routers[indexPath.row]
        router.clicked = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        let router = routers[indexPath.row]
        router.clicked = false
    }
    
    //MARK: Segue Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RoutersToJunosFiles") {
            let secondViewController = segue.destination as! SelectJunosFileViewController
            secondViewController.files = files
            
        }
    }
    
    //MARK: Custom Functions
    
    //function executes every time data flows from Python --> iPad
    func send(str: String) {
        processInputString(str: str)
    }
    
    var files: [String] = []
    var firstTime = true
    func processInputString(str: String) {
        files = str.components(separatedBy: "\n")
        if firstTime == true {
            performSegue(withIdentifier: "RoutersToJunosFiles", sender: nil)
            firstTime = false
        }
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
    
    
}

