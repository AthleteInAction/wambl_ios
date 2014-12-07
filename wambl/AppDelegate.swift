//
//  AppDelegate.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

var root: UIWindow!

var currentUser: PFUser!
var account_info: String!

let docs_folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
let file_name = "/info.wambl"
let info_path = docs_folder.stringByAppendingString(file_name)

var CONTACTS = AppContacts()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSLog("A")
        
        root = window
        
        Parse.setApplicationId(
            "WqXGBQrglXMAJ3lBDTQIXkd8LPPZN08bJvgJe8ch",
            clientKey: "syNLknqjG5gQMunUMgnv2Ng1Wj6H6WdMbzRyXvGW"
        )
        
        PFUser.logOut()
        
        currentUser = PFUser.currentUser()
        
        var file_manager = NSFileManager.defaultManager()
        
        if !file_manager.fileExistsAtPath(info_path) {
            
            NSLog("\(info_path) does not exist")
            var text = ""
            text.writeToFile(info_path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            
        }
        
        account_info = String(contentsOfFile: info_path, encoding: NSUTF8StringEncoding, error: nil)
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        NSLog("B")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NSLog("C")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    var a: Bool = false
    func applicationWillEnterForeground(application: UIApplication) {
        NSLog("D")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        CONTACTS.update({(s) -> Void in})
        a = true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSLog("E")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if !a {
            CONTACTS.update({(s) -> Void in})
            a = false
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        NSLog("F")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

