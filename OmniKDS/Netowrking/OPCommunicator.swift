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
        
        startInitials()
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
        
        let key : NSString = dict?.value(forKey: NIK.SYNC_ACTION) as! NSString
        if key.isEqual(to: NIK.SYNC_ACTION_KITCHEN_DOCKETS){
            
            let key2 : NSString = dict?.value(forKey: NIK.AUTH) as! NSString
            if key2.isEqual(to: NIK.SIGNATURE){
                
                let msgBody : String = dict?.value(forKey: NIK.MESSAGE) as! String
                if msgBody.count>0
                {
                    print("Received data on KDS: \(msgBody)")
                    var dictionary : Dictionary<String, Any>?
                    let data = Data(msgBody.utf8)
                        
                    do{
                        dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        
                        let dict = NSDictionary(dictionary: dictionary!)
                        if dict != nil{
                            
                            let newOrder = Order.createOrderFromJSONDict(jsonDict: dict, container: sharedCoredataCoordinator.persistentContainer)
                            if newOrder != nil{
                                
                            }
                        }
                    }catch let error as NSError{
                        
                        print("error in parsing \(error.userInfo)")
                    }
                }
            }
        }
    }
}
