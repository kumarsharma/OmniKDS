//
//  KDCoreDataCoordinator.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 09/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import CoreData

let sharedCoredataCoordinator = KDCoreDataCoordinator ()

class KDCoreDataCoordinator: NSObject {

    override init() {
            
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
    lazy var persistentContainer: NSPersistentContainer={
        
        let container = NSPersistentContainer(name:"OmniKDS");
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        if context.hasChanges{
            
            do{
                try context.save()
            } catch{
                
                let nserror = error as NSError
                fatalError("Got error in context save \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
