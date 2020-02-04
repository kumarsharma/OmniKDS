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
    
    // we use a global admin user to easyly access the app.
    // following method fetches the global-admin user, if first time, it creates new
    class func addDefaultAdminUser() {
        
        let predicate = NSPredicate(format: "isAdmin=true")
        var adminUser : KitchenUser? = nil
        
        do {
            try adminUser = self.fetchObjectWithPredicate(predicate: predicate) as? KitchenUser
        } catch DBError.NoObjectFound {
            
            adminUser=nil
        }
        catch{
            
            adminUser=nil
        }
        
        if adminUser==nil{
            
            adminUser = self.addNewUser(firstName: "Admin", lastName: "Admin", isAdmin: true, email: "email@example.com", phone: "1234567890", userPIN: "\(GlobalAdminUserID)")
            sharedCoredataCoordinator.saveContext()
        }
        else{
            
            print("Admin User is Active!!")
        }
    }
    
    //following method adds a new user
    class func addNewUser(firstName:String, lastName:String, isAdmin:Bool, email:String, phone:String, userPIN:String) -> KitchenUser{
        
        var newUser : KitchenUser?
        let userEntity = NSEntityDescription.entity(forEntityName: "KitchenUser", in: sharedCoredataCoordinator.persistentContainer.viewContext)
        newUser = NSManagedObject(entity: userEntity!, insertInto: sharedCoredataCoordinator.persistentContainer.viewContext) as? KitchenUser
        newUser?.firstName=firstName
        newUser?.lastName=lastName
        newUser?.isAdmin=isAdmin
        newUser?.email=email
        newUser?.phone=phone
        newUser?.userPIN=userPIN
        newUser?.userId=UUID().uuidString
        
        return newUser!
    }
    
    class func authenticateUserWithPIN(pin:String) -> Bool{
        
        let predicate = NSPredicate(format: "userPIN=\(pin)")
        var user : KitchenUser? = nil
        
        do {
            try user = self.fetchObjectWithPredicate(predicate: predicate) as? KitchenUser
        } catch {
            
            user=nil
        }
        
        if user==nil{
            
            return false
        }
        else{
            
            return true
        }
    }
    
      class func viewFetchRequest()->NSFetchRequest<NSFetchRequestResult>{
           
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "KitchenUser")
            let sd = NSSortDescriptor(key: "firstName", ascending: true)
            fetchRequest.sortDescriptors = [sd]
            return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
       }
}
