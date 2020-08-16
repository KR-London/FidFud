//
//  SceneDelegate.swift
//  FudFid
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
         //let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let launchedBefore = true
        //let newTutorial = false
        
        if launchedBefore{

            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            self.window = UIWindow(windowScene: windowScene)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "mainTabBarController") as? UITabBarController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        }
            //        else
            //        {
            //            if newTutorial{
            //                self.window = UIWindow(frame: UIScreen.main.bounds)
            //
            //                let storyboard = UIStoryboard(name: "ExtraTutorial", bundle: nil)
            //
            //                let initialViewController = storyboard.instantiateViewController(withIdentifier: "p1" )
            //                self.window?.rootViewController = initialViewController
            //            }
        else{
            // UserDefaults.standard.set(true, forKey: "launchedBefore")

            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            
            self.window = UIWindow(windowScene: windowScene)
            //self.window =  UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "p1") as? Onboarding1ViewController else {
                print("ViewController not found")
                return
            }
          //  let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

