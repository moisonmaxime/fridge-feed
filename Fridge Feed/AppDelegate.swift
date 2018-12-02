//
//  AppDelegate.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 11/29/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        UserSettings.accessKey = nil
        
        //        RestAPI.login(user: "maximaxof", password: "password", completionHandler: {}, errorHandler: { _ in })
        
        //        RestAPI.register(user: "maximaxof", password: "password", email: "max@me.com", name: "maxime", completionHandler: {
        //            print("SUCCESS")
        //        }, errorHandler: { error in
        //            print("Error: \(error.message)")
        //        })
        
        //        RestAPI.createContainer(name: "max's fridge", type: "some type of fridge", completionHandler: {
        //            print("SUCCESS")
        //        }, errorHandler: { error in
        //            print("Error: \(error.message)")
        //        })
        
        //        RestAPI.addItem(container: 1, name: "food", expiration: Date(), completionHandler: {
        //            print("SUCCESS")
        //        }, errorHandler: { error in
        //            print("Error: \(error.message)")
        //        })
        
//        RestAPI.updateContainer(id: 2, name: "new name", type: "new type", completionHandler: {
//            print("SUCCESS")
//        }, errorHandler: { error in
//            print("Error: \(error.message)")
//        })
        
        RestAPI.deleteContainer(id: 2, completionHandler: {
            print("SUCCESS")
        }, errorHandler: { error in
            print("Error: \(error.message)")
        })
        
        RestAPI.listContainers(completionHandler: { (containers) in
            for container in containers {
                print("\(container.id) - \(container.name)")
            }
        }) { (error) in
            print(error.message)
        }
        
        RestAPI.getContainer(id: 1, completionHandler: { (container) in
            print(container)
            for item in container.items {
                print(item.expiration)
            }
        }) { (error) in
            print(error.message)
        }
        
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
    
    
}

