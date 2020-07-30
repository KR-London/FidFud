//
//  AppDelegate.swift
//  FudFid
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
            FirebaseApp.configure()

//            //let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//            /// for testing
//            // doIPlaceANewDatestamp()
//            let launchedBefore = false
//            //let newTutorial = false
//            
//            if launchedBefore{
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "mainTabBarController" )
//                self.window?.rootViewController = initialViewController
//                
//                //   let nextViewController = storyboard.instantiateViewController(withIdentifier: "newDataInputViewController" )
//                //self.window?.rootViewController!.push(nextViewController, animated: true, completion: nil)
//                self.window?.makeKeyAndVisible()
//                
//            }
//                //        else
//                //        {
//                //            if newTutorial{
//                //                self.window = UIWindow(frame: UIScreen.main.bounds)
//                //
//                //                let storyboard = UIStoryboard(name: "ExtraTutorial", bundle: nil)
//                //
//                //                let initialViewController = storyboard.instantiateViewController(withIdentifier: "p1" )
//                //                self.window?.rootViewController = initialViewController
//                //            }
//            else{
//                // UserDefaults.standard.set(true, forKey: "launchedBefore")
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                
//                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//                
//                //let initialViewController = storyboard.instantiateViewController(withIdentifier: "o1" )
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "p1" )
//                
//                self.window?.rootViewController = initialViewController
//                self.window?.makeKeyAndVisible()
//            }

            return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
  

    // MARK: - Core Data stack

    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "FudFid")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 13.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

