//
//  AppDelegate.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Date(),"-- didFinishLaunchingWithOptions()")
        // Get Identifier for Vendor (IDFV)
        print(Date(), "-- IDFV:",UIDevice().identifierForVendor!.uuidString)
        
        // Add 3rd Party Code Here:
        if let config = self.getConfig() {
            config.launchOptions = launchOptions
            Singular.start(config)
        }
        
        return true
    }

    func getConfig() -> SingularConfig? {
        guard let config = SingularConfig(apiKey: Constants.APIKEY, andSecret: Constants.SECRET) else {
            return nil
        }
        // Enable use of SKAN for iOS14 tracking
        // Singular will call registerAppForAdNetworkAttribution for you
        // Invoking [Singular skanRegisterAppForAdNetworkAttribution] will set this value to YES, even if done before/after [Singular start]
        config.skAdNetworkEnabled = true
        
        // Delay sending events for up to 3 minutes, or until Tracking is Authorized (only on iOS 14)
        config.waitForTrackingAuthorizationWithTimeoutInterval = 180
        
        // Enable manual conversion value updates
        // IMPORTANT: set as NO (or just don't set - it defaults to NO) to let Singular manage conversion values
        config.manualSkanConversionManagement = false
        config.conversionValueUpdatedCallback = { newConversionValue in
            // Receive a callback whenever the Conversion Value is updated
        }
        
        return config
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

