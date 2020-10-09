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
        var headerDict : NSDictionary? = nil
        
        do{
            try headerDict = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSDictionary
        }catch let error as NSError{
            
            print("Error in parsing data: Error \(error.userInfo)")
        }
        
        let key : NSString = headerDict?.value(forKey: NIK.SYNC_ACTION) as! NSString
        if key.isEqual(to: NIK.SYNC_ACTION_KITCHEN_DOCKETS){
            
            let key2 : NSString = headerDict?.value(forKey: NIK.AUTH) as! NSString
            if key2.isEqual(to: NIK.SIGNATURE){
                
                let msgBody : String = headerDict?.value(forKey: NIK.MESSAGE) as! String
                if msgBody.count>0
                {
                    print("Received data on KDS: \(msgBody)")
                    var dictionary : Dictionary<String, Any>?
                    let data = Data(msgBody.utf8)
                        
                    do{
                        dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        
                        let bodyDict = NSDictionary(dictionary: dictionary!)
                            
                        _ = Order.createOrderFromJSONDict(jsonDict: bodyDict, container: sharedCoredataCoordinator.persistentContainer)
                        sharedCoredataCoordinator.saveContext()
                            
                        //send acknowledgement
                        var host : NSString? = ""
                        var port : UInt16? = 0
                        GCDAsyncUdpSocket.getHost(&host, port: &port!, fromAddress: address)
                        if host != nil{
                            
                            let hhost = host as String?
                            var addr = sockaddr_in()
                            addr.sin_addr = in_addr(s_addr: inet_addr(hhost))
                            addr.sin_family = sa_family_t(AF_INET)
                            addr.sin_len = UInt8(MemoryLayout.size(ofValue: addr))
                            addr.sin_port = (Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port!) : port)!                            
                            let cfData = NSData(bytes: &addr, length: MemoryLayout<sockaddr_in>.size) as CFData
                            let addr_data = cfData as Data?
                            
                            let sentKey = headerDict!.value(forKey: NIK.CURRENT_SENT_KEY)
                            let returnDict = [NIK.SYNC_ACTION:NIK.SYNC_ACTION_ACKKNOWLEDGEMENT, NIK.CURRENT_SENT_KEY:sentKey]
                            
                            let ackData = try NSKeyedArchiver.archivedData(withRootObject: returnDict, requiringSecureCoding: false)
                            
                            self.udpSocket.send(ackData, toAddress: addr_data, withTimeout: 60, tag: 1)
                        }
                    }catch let error as NSError{
                        
                        print("error in parsing \(error.userInfo)")
                    }
                }
            }
        }
    }
}
