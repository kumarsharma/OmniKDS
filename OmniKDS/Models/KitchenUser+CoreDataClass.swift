//
//  KitchenUser+CoreDataClass.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
//

import Foundation
import CoreData

@objc(KitchenUser)
public class KitchenUser: OPManagedObject {

    override class func primaryKeyName() -> String {
        
        return "userId"
    }
    
    class func addDefaultAdminUser() {
        
        let predicate = NSPredicate(format: "isAdmin=true")
        var adminUser = self.fetchObjectWithPredicate(predicate: predicate) as? KitchenUser
        if adminUser==nil{
            
            adminUser = self.addNewUser(firstName: "Admin", lastName: "Admin", isAdmin: true, email: "email@example.com", phone: "1234567890", userPIN: "9999")
            sharedCoredataCoordinator.saveContext()
        }
        else{
            
            print("Admin User is Active!!")
        }
    }
    
    
    class func addNewUser(firstName:String, lastName:String, isAdmin:Bool, email:String, phone:String, userPIN:String) -> KitchenUser{
        
        var newUser : KitchenUser?
        let userEntity = NSEntityDescription.entity(forEntityName: "KitchenUser", in: sharedCoredataCoordinator.persistentContainer.viewContext)
        newUser = NSManagedObject(entity: userEntity!, insertInto: sharedCoredataCoordinator.persistentContainer.viewContext) as? KitchenUser
        newUser?.firstName="Admin"
        newUser?.lastName="Admin"
        newUser?.isAdmin=true
        newUser?.email="email@example.com"
        newUser?.phone="1234567890"
        newUser?.userPIN="9999"
        newUser?.userId=UUID().uuidString
        
        return newUser!
    }
}
