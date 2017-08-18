//
//  TCPSetupViewController.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 8/16/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import UIKit

class TCPSetupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.enterTCPInfo))
        navigationItem.rightBarButtonItem = doneButton
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Enter TCP Connection Parameters"
    }
    
    @IBOutlet weak var IP1: UITextField!
    @IBOutlet weak var IP2: UITextField!
    @IBOutlet weak var IP3: UITextField!
    @IBOutlet weak var IP4: UITextField!
    @IBOutlet weak var Port: UITextField!

    
    func makeIPAddress(ip1: String, ip2: String, ip3: String, ip4: String) -> CFString {
    
        let finalIP = ip1 + "." + ip2 + "." + ip3 + "." + ip4
        return finalIP as CFString
        
    }
    
    func enterTCPInfo() {
        
        guard  let ip1 = IP1.text else {
            print("Error: Need to assign IP address")
            return
        }
        guard  let ip2 = IP2.text else {
            print("Error: Need to assign IP address")
            return
        }
        guard  let ip3 = IP3.text else {
            print("Error: Need to assign IP address")
            return
        }
        guard  let ip4 = IP4.text else {
            print("Error: Need to assign IP address")
            return
        }
        guard  let port = Port.text else {
            print("Error: Need to assign port number")
            return
        }
        let portNumber = Int(port)
        let portInt32 = UInt32(portNumber!)
        serverAddress = makeIPAddress(ip1: ip1, ip2: ip2, ip3: ip3, ip4: ip4)
        serverPort = portInt32
        print ("your IP address is \(serverAddress) and port number is \(serverPort)")
        
        if firstCommand == "Show Configuration" {
            performSegue(withIdentifier: "tcpToRouterCommand", sender: nil)
        } else {
            performSegue(withIdentifier: "tcpToLab", sender: nil)
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
