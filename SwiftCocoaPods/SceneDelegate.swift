//
//  SceneDelegate.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import AdSupport
import Singular
import AdSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(Date(), "-- sceneWillConnectTo()")
        
        let userActivity = connectionOptions.userActivities.first
        
            // Printing Identifier for Vendor (IDFV) to Xcode Console for use in Singular SDK Console
            print(Date(), "-- Scene Delegate IDFV:", UIDevice().identifierForVendor!.uuidString as Any)
            
            // (Optional) Get 3rd Party Identifiers to set in Global Properties:
            // If 3rd party SDKs are providing any identifiers to Singular, the respective SDK must be initialized before Singular.
            // Initialize third party SDK here and get/set variables needed for Singular.
            let thirdPartyKey = "anonymousID"
            let thirdPartyID = "2ed20738-059d-42b5-ab80-5aa0c530e3e1"
            
            //Initialize the Singular SDK here:
            if let config = self.getConfig() {
                config.userActivity = userActivity
                // Using Singular Global Properties feature to capture third party identifiers
                config.setGlobalProperty(thirdPartyKey, withValue: thirdPartyID, overrideExisting: true)
                Singular.start(config)
            }
            
            // Request App Tracking Transparency when the App is Ready, provides IDFA on consent to Singular SDK
            Utils.requestTrackingAuthorization()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(Date(), "-- sceneContinueUserActivity")
        
        // Capture the OpenURL and store in UserDefaults
        let openurlString = userActivity.webpageURL?.absoluteString
        UserDefaults.standard.set(openurlString, forKey: Constants.OPENURL)
        
        // Starts a new Singular session on continueUserActivity
        if let config = self.getConfig() {
            config.userActivity = userActivity
            Singular.start(config)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(Date(), "-- openURLContexts")
        
        // Capture the OpenURL and store in UserDefaults
        let openurlString = URLContexts.first?.url
        UserDefaults.standard.set(openurlString?.absoluteString, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(openurlString?.absoluteString, forKey: Constants.OPENURL)
        
        // Starts a new Singular session on cold start from deeplink scheme
        if let config = self.getConfig() {
            config.openUrl = openurlString
            Singular.start(config)
        }
        
        // Redirect to the DeeplinkController if Non-Singular deeplink exists
        if (!Utils.isEmptyOrNull(text: openurlString?.absoluteString)) {
            DispatchQueue.main.async(execute: { [self] in
                let tabBar = window?.rootViewController as? TabController
                tabBar?.openedWithDeeplink()
            })
        }
    }
    
    func getConfig() -> SingularConfig? {
        print(Date(), "-- Scene Delegate getConfig")
        
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
        print(Date(), "-- Scene Delegate processDeeplink()")
        
        // Get Deeplink data from Singular Link
        let deeplink = params.getDeepLink()
        let passthrough = params.getPassthrough()
        let isDeferredDeeplink = params.isDeferred() ? "Yes" : "No"

        // Store deeplink data in UserDefaults for access from DeeplinkController
        UserDefaults.standard.set(deeplink, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(passthrough, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(isDeferredDeeplink, forKey: Constants.IS_DEFERRED)
        
        // Redirect to the DeeplinkController if deeplink exists
        if (!Utils.isEmptyOrNull(text: deeplink)) {
            DispatchQueue.main.async(execute: { [self] in
                let tabBar = window?.rootViewController as? TabController
                tabBar?.openedWithDeeplink()
            })
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print(Date(), "-- sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print(Date(), "-- sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print(Date(), "-- sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print(Date(), "-- sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print(Date(), "-- sceneDidEnterBackground")
    }
}


