//
//  ViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/18/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, dataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        connection.connect() //connect socket
        connection.sendDelegate = self //lets the connection send data to the view controller
        
        //secure text entry
        usernameTextField.clearsOnInsertion = true
        passwordTextField.clearsOnInsertion = true
        usernameTextField.isSecureTextEntry = false
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Enter Login Credentials"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Variables and Constants
    
    let connection = Connection() //set up instance of iPad-Python server connection object
    
    //MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions

    @IBAction func pressEnter(_ sender: Any) {
        sendMessageToPython(str: "\(usernameTextField.text!)\n")
        sendMessageToPython(str: "\(passwordTextField.text!)\n")
    }
    
    //MARK: Functions
    
    //function executes every time data flows from Python --> iPad
    func send(str: String) {
        processInputString(str: str)
    }
    
    //Process Strings coming from Python --> iPad
    
    var firstTime:Bool = true
    func processInputString(str: String) {
        let strVec = str.components(separatedBy: "\n")
        if (strVec[0] == "loggedIn") && (firstTime) {
            performSegue(withIdentifier: "GoToSelectAction", sender: nil)
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

