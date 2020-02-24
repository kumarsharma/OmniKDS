//
//  AppDelegate.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 03/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

/**
 
 Desc: OmniKDS is a Kitchen Display System for showing currently confirmed orders on targeted kitchens. 
 It is available as a ready-made setup KDS. No need to configure anything. Sample orders are shown when the app is opened. 
  Once ready to user, just press the button "Ready to Use". To see the sample orders go to Settings and select "Reload Sample orders".
 
 */

import UIKit
import CoreData

var loggedInUser : KitchenUser?
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var sharedKitchen : OmniKitchen? = nil
        sharedKitchen = OmniKitchen.getSharedKItchen(container: sharedCoredataCoordinator.getPersistentContainer())
        KitchenUser.addDefaultAdminUser()
        
        if sharedKitchen==nil{
            
            print("Unable to start kitchen display!!")
        }
        else{
            
            print("ready to go!! good luck!!!!!")
        }
        
        sharedCommunicator.startServer()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

