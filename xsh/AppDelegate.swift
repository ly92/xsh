//
//  AppDelegate.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //单例
    class var sharedInstance : AppDelegate{
        guard let single = UIApplication.shared.delegate as? AppDelegate else{
            return AppDelegate()
        }
        return single
    }
    
    
    let tabBar = LYTabBarController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController = tabBar
        if LocalData.getYesOrNotValue(key: KIsLoginKey){
            self.checkLogin()
        }
        self.checkVersion()
        
        
        
        
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue)
        DispatchQueue.main.async {
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: nil)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if LocalData.getYesOrNotValue(key: KIsLoginKey){
            self.checkLogin()
        }
        self.checkVersion()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "xsh")
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.description.replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: " ", with: "")
        LocalData.saveToken(token: token)
    }

    // MARK: - Core Data Saving support

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



extension AppDelegate {
    
    //检测是否需要重新登录
    func checkLogin() {
        var params : [String : Any] = [:]
        params["device"] = LocalData.getToken()
        NetTools.requestData(type: .post, urlString: CheckTokenApi, parameters: params, succeed: { (result) in
            //0:重新登录，1:正常
            if result["result"].stringValue.intValue == 0{
                guard let nav = self.tabBar.selectedViewController as? LYNavigationController else{
                    return
                }
                let loginVC = LoginViewController.spwan()
                nav.viewControllers.first?.present(loginVC, animated: true) {
                }
            }else if result["result"].stringValue.intValue == 1{
            }
        }) { (error) in
            guard let nav = self.tabBar.selectedViewController as? LYNavigationController else{
                return
            }
            let loginVC = LoginViewController.spwan()
            nav.viewControllers.first?.present(loginVC, animated: true) {
            }
            LYProgressHUD.showError(error)
        }
    }
    
    
    //检测版本号
    func checkVersion() {
        var params : [String : Any] = [:]
        params["platform"] = "ios"
        NetTools.requestData(type: .post, urlString: CheckVersionApi, parameters: params, succeed: { (result) in
            let localVersion = appVersion().replacingOccurrences(of: ".", with: "").intValue
            let netVersion = result["ver"]["versionid"].stringValue.intValue
            let isForce = result["ver"]["force"].stringValue.intValue
            var message = result["ver"]["log"].stringValue
            var url = result["ver"]["filepath"].stringValue
            if message.trim.isEmpty{
                message = "APP有新版本更新，为了您的使用体验，请到App Store下载更新"
            }
            if url.trim.isEmpty{
                url = "itms-apps://itunes.apple.com/cn/app/id1049692770?mt=8"
            }
            if localVersion < netVersion{
                if isForce == 1{
                    LYAlertView.show("提示", message,"去更新",{
                        let urlStr = url
                        if UIApplication.shared.canOpenURL(URL(string:urlStr)!){
                            UIApplication.shared.open(URL(string:urlStr)!, options: [:], completionHandler: nil)
                        }
                    })
                }else{
                    LYAlertView.show("提示", message,"下次再说","去更新",{
                        let urlStr = url
                        if UIApplication.shared.canOpenURL(URL(string:urlStr)!){
                            UIApplication.shared.open(URL(string:urlStr)!, options: [:], completionHandler: nil)
                        }
                    })
                }
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    
    
}
