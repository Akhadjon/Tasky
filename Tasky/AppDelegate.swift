//
//  AppDelegate.swift
//  Tasky
//
//  Created by Akhadjon Abdukhalilov on 9/9/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
         window?.rootViewController = UINavigationController(rootViewController: HomeVC())
        window?.makeKeyAndVisible()
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).last! as String )
        
        return true
    }

    


}

