//
//  AppDelegate.swift
//  merchant
//
//  Created by Eugenio Mercado on 13/06/18.
//  Copyright © 2018 Eugenio Mercado. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import GoogleSignIn
import ApiAI
import Stripe

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        STPTheme.default().accentColor = UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)
        STPTheme.default().primaryBackgroundColor = UIColor.white
        STPTheme.default().secondaryBackgroundColor = UIColor.groupTableViewBackground
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        // Navbar style
        let navigationBarAppearace = UINavigationBar.appearance()
       // navigationBarAppearace.tintColor = UIColor.white
       // navigationBarAppearace.barTintColor = UIColor(red:0.11, green:0.68, blue:0.83, alpha:1.0)

        navigationBarAppearace.tintColor = UIColor(red:0.04, green:0.64, blue:0.80, alpha:1.0)
        navigationBarAppearace.barTintColor = UIColor.white
        
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        // Google
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "5d9d849be30f400089f781b3a479644f"
        
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        
        // Core data URL
        let container = NSPersistentContainer(name: "transactionsData")
        print(container.persistentStoreDescriptions.first?.url)
        
        // Stripe API
        STPPaymentConfiguration.shared().publishableKey = "pk_live_8JbHy2InoW6uXM6YsVuMCiuv"
        
        return true
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Quick action code
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.youtap.qrCode"{
           
            
            completionHandler(true)
            
        } else if shortcutItem.type == "Type02" {
            
            
            completionHandler(true)
            
        } else if shortcutItem.type == "Type03" {
            
            
        } else {
             
            completionHandler(false)
        }
        
        
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
     
        let container = NSPersistentContainer(name: "transactionsData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } 
    }



}
