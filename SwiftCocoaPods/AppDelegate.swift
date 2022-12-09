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
        print(Date(), "-- didFinishLaunchingWithOptions()")
        
        // Printing Identifier for Vendor (IDFV) to Xcode Console for use in Singular SDK Console
        print(Date(), "-- App Delegate IDFV:", UIDevice().identifierForVendor!.uuidString as Any)
        
        // (Optional) Get 3rd Party Identifiers to set in Global Properties:
        // If 3rd party SDKs are providing any identifiers to Singular, the respective SDK must be initialized before Singular.
        // Initialize third party SDK here and get/set variables needed for Singular.
        let thirdPartyKey = "anonymousID"
        let thirdPartyID = "2ed20738-059d-42b5-ab80-5aa0c530e3e1"
        
        //Initialize the Singular SDK here:
        if let config = self.getConfig() {
            config.launchOptions = launchOptions
            // Using Singular Global Properties feature to capture third party identifiers
            config.setGlobalProperty(thirdPartyKey, withValue: thirdPartyID, overrideExisting: true)
            Singular.start(config)
        }
        
        // Request App Tracking Transparency when the App is Ready, provides IDFA on consent to Singular SDK
        Utils.requestTrackingAuthorization()
        
        return true
    }
    
    func getConfig() -> SingularConfig? {
        print(Date(), "-- App Delegate getConfig")
        
        // Singular Config Options
        guard let config = SingularConfig(apiKey: Constants.APIKEY, andSecret: Constants.SECRET) else {
            return nil
        }
        config.skAdNetworkEnabled = true
        config.waitForTrackingAuthorizationWithTimeoutInterval = 300
        config.supportedDomains = ["www.jaredornstead.com"]
        config.singularLinksHandler = { params in
            self.processDeeplink(params: params)
        }
        return config
    }
    
    func processDeeplink(params: SingularLinkParams!) {
        print(Date(), "-- App Delegate processDeeplink()")

        // Get Deeplink data from Singular Link
        let deeplink = params.getDeepLink()
        let passthrough = params.getPassthrough()
        let isDeferredDeeplink = params.isDeferred() ? "Yes" : "No"

        // Store deeplink data in UserDefaults for access from DeeplinkController
        UserDefaults.standard.set(deeplink, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(passthrough, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(isDeferredDeeplink, forKey: Constants.IS_DEFERRED)

        // Redirect to the DeeplinkController if deeplink exists
        if (!Utils.isEmptyOrNull(text: deeplink)){
            DispatchQueue.main.async {
                if let tabBar = UIApplication.shared.windows.first?.rootViewController as? TabController {
                    tabBar.openedWithDeeplink()
                }
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
