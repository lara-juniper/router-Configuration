//
//  ShowConfigReportViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/17/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class ShowConfigReportViewController: UIViewController, dataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = wholeString
        
        connection.connect() //connect socket
        connection.sendDelegate = self //lets the connection send data to the view controller
        
        var notConnected = true
        while notConnected {
            if connection.outputStream.hasSpaceAvailable {
                sendMessageToPython(str: "nav:configReport\n")
                notConnected = false
                sendCommandString()
            }
        }
        
        let doneButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.startOver))
        navigationItem.rightBarButtonItem = doneButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Router Information is Displayed Below"
    }
    
    //Mark: Outlets
    
    
    @IBOutlet weak var textView: UITextView!
    
    //MARK: Custom Objects
    
    var selectedRouter: String = ""
    var messageToPython: String = ""
    let connection = Connection()
    var wholeString: String = ""

    
    func send(str: String) {
        processInputString(str: str)
    }
    
    func processInputString(str: String) {
        
        wholeString = wholeString + str
        
        textView.text = wholeString
    }
    
    func sendCommandString() {
        var notConnected = true
        while notConnected {
            if connection.outputStream.hasSpaceAvailable {
                sleep(2)
                let strToSend = "\(selectedRouter):\(messageToPython)\n"
                self.sendMessageToPython(str: strToSend)
                notConnected = false
            }
        }
    }
    
    func startOver() {
        performSegue(withIdentifier: "returnHome", sender: nil)
    }
    
    //send message iPad --> Python
    func sendMessageToPython(str: String) {
        var arrayToServer: [UInt8] = [] //initialize array to be sent to server
        arrayToServer = Array(str.utf8)
        if connection.outputStream.hasSpaceAvailable { //If there is space available on the output stream (i.e. you're not sending too much data at once)
            let bytes = connection.outputStream.write(&arrayToServer, maxLength: arrayToServer.count) //write message to output stream
            print("\(bytes) were sent to Python") //print how many bytes of data were sent
        } else { //error if you're trying to send too much data
            print("Error: no space available for writing")
        }
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
