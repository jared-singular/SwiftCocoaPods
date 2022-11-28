//
//  SceneDelegate.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import AdSupport
import Singular

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var deeplinkData:[String:AnyObject]?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let userActivity = connectionOptions.userActivities.first, let config = self.getConfig() {
            // Starts a new session when the user opens the app using a Singular Link while it was in the background
            config.userActivity = userActivity
            Singular.start(config)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // Starts a new session when the user opens the app using a Singular Link while it was in the background
        if let config = self.getConfig() {
            config.userActivity = userActivity
            Singular.start(config)
        }
    }
    
    func getConfig() -> SingularConfig? {
        guard let config = SingularConfig(apiKey: Constants.APIKEY, andSecret: Constants.SECRET) else {
            return nil
        }
        config.singularLinksHandler = { params in
            if let params = params {
                self.handleSingularLink(params: params)
            }
        }
        return config
    }

    func handleSingularLink(params: SingularLinkParams) {
        
        var values = [String: AnyObject]()
        values[Constants.DEEPLINK] = params.getDeepLink() as AnyObject
        values[Constants.PASSTHROUGH] = params.getPassthrough() as AnyObject
        values[Constants.IS_DEFERRED] = params.isDeferred() as AnyObject
        
        deeplinkData = values
        
        navigateToDeeplinkController()
    }
    
    func navigateToDeeplinkController() {
        // UI changes must run on main thread
        print(Constants.DEEPLINK)
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

