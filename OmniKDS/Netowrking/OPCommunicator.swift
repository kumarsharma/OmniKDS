//
//  OPCommunicator.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

let sharedCommunicator = OPCommunicator()
class OPCommunicator: NSObject, GCDAsyncUdpSocketDelegate {

    var udpSocket : GCDAsyncUdpSocket!
    
    override init() {
    }
    
    func startInitials() {
        
        udpSocket = GCDAsyncUdpSocket(delegate: sharedCommunicator, delegateQueue: DispatchQueue.main)
        sharedCommunicator.registerForReachabilityChangeNotification()
    }
    
    func registerForReachabilityChangeNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: NSNotification.Name(rawValue: kReachabilityChangedNotification), object: nil)
    }
    
    @objc func reachabilityChanged(_ notification: NSNotification) {
        
        
    }
    
    func startServer() {
        
        let port : UInt16 = 6002
        
        do{
            try self.udpSocket.bind(toPort: port)
        }catch let error as NSError {
            
            print("UDP Socket Start Error. Error: \(error.userInfo)")
            return
        }
        
        do{
            try self.udpSocket.beginReceiving()
        }catch let error as NSError{
            
            print("UDP Socket receiving error. Error: \(error.userInfo)")
            return
        }
        
        print("Socket is listening at PORT: \(port)")
    }
    
    func stopServer(){
        
        self.udpSocket.close()
        self.udpSocket=nil
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket!, didReceive data: Data!, fromAddress address: Data!, withFilterContext filterContext: Any!) 
    {
        var dict : NSDictionary? = nil
        
        do{
            try dict = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
        }catch let error as NSError{
            
            print("Error in parsing data: Error \(error.userInfo)")
        }
        
        let key : NSString = dict?.value(forKey: kSYNC_ACTION) as! NSString
        if key.isEqual(to: kSYNC_ACTION_KITCHEN_DOCKETS){
            
            let key2 : NSString = dict?.value(forKey: kAUTH) as! NSString
            if key2.isEqual(to: kSIGNATURE){
                
                let msgBody : NSString = dict?.value(forKey: kMESSAGE) as! NSString
                if msgBody.length>0
                {
                    print("Received data on KDS: \(msgBody)")
                    var dictionary : NSDictionary?
                    if let data = msgBody.data(using: String.Encoding.utf8.rawValue){
                        
                        do{
                            dictionary = try JSONSerialization.data(withJSONObject: data, options: []) as? [String:AnyObject] as NSDictionary?
                            
                            if dictionary != nil{
                                
                                
                            }
                        }catch let error as NSError{
                            
                            print("error in parsing \(error.userInfo)")
                        }
                    }
                }
            }
        }
    }
}
