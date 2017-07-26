//
//  LabSelectViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/19/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class LabSelectViewController: UIViewController, dataDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lab2Button.isEnabled = false
        lab3Button.isEnabled = false
        
        connection.connect()
        connection.sendDelegate = self
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Select Lab"
    }
    //MARK: Outlets
    @IBOutlet weak var lab1Button: UIButton!
    
    @IBOutlet weak var lab2Button: UIButton!
    
    @IBOutlet weak var lab3Button: UIButton!
    
    //MARK: Objects
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    var junosFiles: [String] = ["Disabled"]
    
    
    
    //MARK: Actions
    @IBAction func lab1ButtonClick(_ sender: Any) {
        sendMessageToPython(str: "check")
    }
    
    
    //MARK: Data sending functions
    
    //function executes every time data flows from Python --> iPad
    func send(str: String) {
        processInputString(str: str)
    }
    

    var firstTime = true
    func processInputString(str: String) {
        let files = str.components(separatedBy: "\n")
        for file in files {
            junosFiles.append(file)
        }
        if firstTime == true {
            performSegue(withIdentifier: "Lab2Routers", sender: nil)
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

    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if (segue.identifier == "Lab2Routers") {
                    let secondViewController = segue.destination as! TableViewController
                    secondViewController.junosFiles = junosFiles
        
                }
    }
}
