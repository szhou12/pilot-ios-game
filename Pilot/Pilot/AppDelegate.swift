//
//  AppDelegate.swift
//  Pilot
//
//  Created by Joshua Zhou on 3/5/19.
//  Copyright © 2019 Shuyu Zhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let kVersion = "CFBundleShortVersionString"
    let kBuildNumber = "CFBundleVersion"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from:Date())
            UserDefaults.standard.set(dateString, forKey: "date_preference")
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        self.createSplashScreen()
        return true
    }
    
    private func createSplashScreen() {
        let launchScreenVC = UIStoryboard.init(name: "LaunchScreen", bundle: nil)
        let rootVC = launchScreenVC.instantiateViewController(withIdentifier: "splashController")
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: rootVC.view.frame.width, height: 21))
        label.center = CGPoint(x: rootVC.view.frame.midX, y: rootVC.view.frame.midY + 200)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = getVersion()
        rootVC.view.addSubview(label)
        
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
        
    }
    
    @objc func dismissSplashController() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil)
        let rootVC = mainVC.instantiateViewController(withIdentifier: "initController")
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
    private func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary[kVersion] as! String
        let build = dictionary[kBuildNumber] as! String
        
        return "Version: \(version) (\(build))"
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

