//
//  Connection.swift
//  iPhoneClient
//
//  Created by Lara Orlandic on 6/6/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import Foundation

var serverAddress: CFString = "172.24.89.25" as CFString //server address of computer you're connecting to. Must be on same network as iPad
var serverPort: UInt32 = 8055 //port to which you are connecting on the server computer

class Connection: NSObject, StreamDelegate {
    
    var inputStream: InputStream! //read-only stream data object
    var outputStream: OutputStream! //write-only stream data object
    var inputBuffer = [UInt8](repeating: 0, count: 1024) //create empty buffer where you store input message
    
    var sendDelegate: dataDelegate? = nil //assign this to viewcontroller to which data will be sent
    
    func connect() {
        print("connecting...")
        
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        //Pair iPad app with TCP Server
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        //designate the Connection class as the delegate for input/output streams
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        //Continuously process inputs and outputs using a new thread
        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream.open() //open input socket
        self.outputStream.open() //open output socket
    }
    
    
    //Stream delegate (i.e. connection object) runs this funciton every time something happens to the stream
    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        print("stream event")
        
        if stream === inputStream {
            
            print("stream type: input")
            
            switch eventCode {
                
            case Stream.Event.openCompleted:
                print("input: openCompleted")
                
            case Stream.Event.hasBytesAvailable:
                print("input: HasBytesAvailable")
                
                while inputStream.hasBytesAvailable {
                    var bytesInBuffer: Int = 0
                    bytesInBuffer = inputStream.read(&inputBuffer, maxLength: inputBuffer.count)
                    let str = String(bytes: inputBuffer, encoding: String.Encoding.utf8)
                    if let sentString = str {
                        print ("\(bytesInBuffer) bytes sent from Python server")
                        print ("\nPython says: \(sentString)\n")
                        if let del = sendDelegate {
                            del.send(str: sentString)
                    
                        }
                    }
                    
                }
          
            case Stream.Event.errorOccurred:
                print("input: Error occured")
                
            case Stream.Event.endEncountered:
                print("input: End encountered")
                
            case Stream.Event.hasSpaceAvailable:
                print("input: Has Space Available")
                
            default:
                print("input: default")
            }
        }
        
        if stream == outputStream {
            
            print("stream type: output")
            
            switch eventCode {
                
            case Stream.Event.hasSpaceAvailable:
                print("output: HasSpaceAvailable")
                
            case Stream.Event.errorOccurred:
                print("output: Error occured")
                
            default:
                print("output: default")
                
            }
            
            
        }
        
    }
    
}

protocol dataDelegate {
    func send(str: String)
}
