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
        
        var notConnected = true
        while notConnected {
            if connection.outputStream.hasSpaceAvailable {
                sendMessageToPython(str: "nav:login\n")
                notConnected = false
            }
        }
        
        let doneButton = UIBarButtonItem(title: "Enter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pressEnter))
        navigationItem.rightBarButtonItem = doneButton

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
    
    var routerDict = [String:String]()
    
    var selectedRouter: String? = nil
    var command: String = ""
    
    //MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions


    
    func pressEnter() {
        sendMessageToPython(str: "\(usernameTextField.text!)\n")
        sendMessageToPython(str: "\(passwordTextField.text!)\n")
        
        let dictString = dictToString(dict: routerDict)
        sleep(1)
        sendMessageToPython(str: dictString)
    
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
            firstTime = false
            if firstCommand == "Show Configuration" {
                performSegue(withIdentifier: "loginToConfigCommands", sender: nil)
            } else {
                performSegue(withIdentifier: "LastSegue", sender: nil)
            }
            
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
    
    func dictToString(dict: [String: String]) -> String {
        var str = "{"
        let components = Array(dict.keys)
        if components.count > 1 {
            for i in 0...(dict.count - 2) {
                str += "'"
                str += components[i]
                str += "':'"
                str += dict[components[i]]!
                str += "',"
            }
        } else if components.count < 1 {
            return "{}\n"
        }
        str += "'"
        str += components[dict.count - 1]
        str += "':'"
        str += dict[components[dict.count - 1]]!
        str += "'"

        str += "}\n"
        print(str)
        return str
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LastSegue") {
            let secondViewController = segue.destination as! ConfigReportViewController
            secondViewController.routerDict = routerDict
            secondViewController.connection = connection
            
        } else if (segue.identifier == "loginToConfigCommands") {
            let secondViewController = segue.destination as! ShowConfigReportViewController
            guard let router = self.selectedRouter else {
                fatalError("No router selected")
            }
            secondViewController.selectedRouter = router
            secondViewController.messageToPython = command
        }
    }
    
    
}

