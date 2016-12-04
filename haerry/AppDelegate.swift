//
//  AppDelegate.swift
//  haerry
//
//  Created by Ferdinand Lösch on 03/12/2016.
//  Copyright © 2016 Ferdinand Lösch. All rights reserved.
//

import UIKit
import Firebase
import PubNub

extension UIApplication {
    var client: PubNub {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Where's our app delegate")
        }
        return appDelegate.client
    }
}




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener  {

    var window: UIWindow?
    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-04cd03f7-3663-49f9-86dd-c51f7f52dd57", subscribeKey: "sub-c-6d62ed1e-b978-11e6-b490-02ee2ddab7fe")
        config.uuid = "ferdiannd"
        let creatingClient = PubNub.clientWithConfiguration(config)
        creatingClient.addListener(self)
        return creatingClient
    }()
    let view = ViewController()
//    private static let _instance = AppDelegate()
//    
//    static var Instance: AppDelegate {
//        return _instance;
//    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel == "events" {
            print("message \(message.debugDescription)")
            guard let messageDict = message.data.message as?  [String: Bool] else {
                return
            }
            guard messageDict["eventAvailable"]! else {
                // the incauter
               return
            }
        
                
            
        }
        
    }
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
              // Subscribe to demo channel with presence observation
        
       self.client.subscribeToChannels(["location","events"], withPresence: true)
       
        
        
        FIRApp.configure()
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

