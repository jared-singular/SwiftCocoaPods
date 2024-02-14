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
            
            //Initialize the Singular SDK here:
            if let config = self.getConfig() {
                config.userActivity = userActivity
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
        
        // (Optional) Get 3rd Party Identifiers to set in Global Properties:
        // If 3rd party SDKs are providing any identifiers to Singular, the respective SDK must be initialized before Singular.
        // Initialize third party SDK here and get/set variables needed for Singular.
        let thirdPartyKey = "anonymousID"
        let thirdPartyID = "2ed20738-059d-42b5-ab80-5aa0c530e3e1"
        
        // Singular Config Options
        guard let config = SingularConfig(apiKey: Constants.APIKEY, andSecret: Constants.SECRET) else {
            return nil
        }
        // If your app is not displaying the App Tracking Transparency pop-up for consent, comment out the next line
        config.waitForTrackingAuthorizationWithTimeoutInterval = 300
        
        // Call AttributionInfoHandler
        config.deviceAttributionCallback = { attributionInfo in
            self.attributionInfoHandler(attributionInfo)
        }
        
        // Call SingularLinkHandler
        config.singularLinksHandler = { params in
            self.handleDeeplink(params: params)
        }
        
        // Using Singular Global Properties feature to capture third party identifiers
        config.setGlobalProperty(thirdPartyKey, withValue: thirdPartyID, overrideExisting: true)
        Singular.setSessionTimeout(120)
        return config
    }
    
    func attributionInfoHandler(_ attributionInfo: [AnyHashable: Any]?) {
        guard let attributionInfo = attributionInfo else {
            print(Date(), "-- Singular attributionInfo is nil")
            return
        }
        print(Date(), "-- Singular Attribution Info: \(attributionInfo)")
        // Add Attribution handling code here
    }
    
    func handleDeeplink(params: SingularLinkParams?) {
        print(Date(), "-- Scene Delegate handleDeeplink()")
        
        // Get Deeplink data from Singular Link
        let deeplink = params?.getDeepLink()
        let passthrough = params?.getPassthrough()
        let isDeferredDeeplink = params?.isDeferred()
        let urlParams = params?.getUrlParameters()
        
        // Add deep link handling code here
        
        // Log SingularLinkParams
        print(Date(), "-- Singular deeplink: \(String(describing: deeplink))")
        print(Date(), "-- Singular passthrough: \(String(describing: passthrough))")
        print(Date(), "-- Singular isDeferred: \(String(describing: isDeferredDeeplink))")
        print(Date(), "-- Singular urlParams: \(String(describing: urlParams))")
        
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


