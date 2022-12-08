//
//  AppDelegate.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Date(), "-- didFinishLaunchingWithOptions()")
        
        // Print Identifier for Vendor (IDFV)
        print(Date(), "App Delegate IDFV:", UIDevice().identifierForVendor!.uuidString as Any)
        
        // Get 3rd Party Identifiers to set in Global Properties:
        let thirdPartyKey = "anonymousID"
        let thirdPartyID = "2ed20738-059d-42b5-ab80-5aa0c530e3e1"
        
        // Add Singular SDK Init Here:
        //Initialize the Singular SDK
        Singular.startSession(Constants.APIKEY, withKey: Constants.SECRET, withSingularLinkHandler: { params in
            //if the app opens on a deep link, callback is triggered
            //handle the values needed for the app
            self.processDeeplink(params: params)
        })
        
        // Request App Tracking Transparency when the App is Ready, provides IDFA on consent to Singular SDK
        Utils.requestTrackingAuthorization()
        
        return true
    }
    
    func processDeeplink(params: SingularLinkParams!) {
        print(Date(), "-- App Delegate processDeeplink()")

        // Get Deeplink data from Singular Link
        let deeplink = params.getDeepLink()
        let passthrough = params.getPassthrough()
        let isDeferredDeeplink = params.isDeferred() ? "Yes" : "No"

        // Store in UserDefaults for access from DeeplinkController
        UserDefaults.standard.set(deeplink, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(passthrough, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(isDeferredDeeplink, forKey: Constants.IS_DEFERRED)
        //UserDefaults.standard.set(openurlString, forKey: Constants.OPENURL)

        // Handle to the DeeplinkController if deeplink exists
        DispatchQueue.main.async {
            if let tabBar = UIApplication.shared.windows.first?.rootViewController as? TabController {
                tabBar.openedWithDeeplink()
            }
            
        }
    
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

