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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let userActivity = connectionOptions.userActivities.first {
            print("Here")
            // Starts a new session when the user opens the app using a Singular Link while it was in the background
            Singular.startSession(Constants.APIKEY, withKey: Constants.SECRET, andUserActivity: userActivity, withSingularLinkHandler: { params in
                self.processDeeplink(params: params)
            }, andSupportedDomains: ["www.jaredornstead.com"])
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(Date(), "-- sceneContinueUserActivity")
        // Capture the OpenURL and store in Dicitionary
        let openurlString = userActivity.webpageURL?.absoluteString
        UserDefaults.standard.set(openurlString, forKey: Constants.OPENURL)
        
        if let config = self.getConfig() {
            config.userActivity = userActivity
            Singular.start(config)
        }
    }
    
    func getConfig() -> SingularConfig? {
        print(Date(), "-- Scene Delegate getConfig")
        guard let config = SingularConfig(apiKey: Constants.APIKEY, andSecret: Constants.SECRET) else {
            return nil
        }
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

        // Store in UserDefaults for access from DeeplinkController
        UserDefaults.standard.set(deeplink, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(passthrough, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(isDeferredDeeplink, forKey: Constants.IS_DEFERRED)
        //UserDefaults.standard.set(openurlString, forKey: Constants.OPENURL)

        // Handle to the DeeplinkController if deeplink exists
        if (!Utils.isEmptyOrNull(text: deeplink)) {
            DispatchQueue.main.async(execute: { [self] in
                let tabBar = window?.rootViewController as? TabController
                tabBar?.openedWithDeeplink()
            })
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print(Date(), "-- sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print(Date(), "-- sceneDidBecomeActive")
        //print("IDFA:", UserDefaults.standard.string(forKey: "idfa") as Any)
        //print("IDFV:", UserDefaults.standard.string(forKey: "idfv") as Any)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print(Date(), "-- sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print(Date(), "-- sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print(Date(), "-- sceneDidEnterBackground")
    }


}


