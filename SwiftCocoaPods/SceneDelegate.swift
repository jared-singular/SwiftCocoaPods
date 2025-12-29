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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
                  options connectionOptions: UIScene.ConnectionOptions) {
        // ANTI-SWIZZLING capture (unchanged)
        let userActivity = connectionOptions.userActivities.first
        let urlContext = connectionOptions.urlContexts.first
        let openUrl = urlContext?.url

        #if DEBUG
        print("[SWIZZLE CHECK] UserActivity captured:", userActivity?.webpageURL?.absoluteString ?? "none")
        print("[SWIZZLE CHECK] URL Context captured:", openUrl?.absoluteString ?? "none")
        print("IDFV:", UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        #endif

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        // Load initial VC from Main.storyboard (your TabController)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rootVC = storyboard.instantiateInitialViewController() else { return }

        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()

        // Singular initialization (unchanged)
        guard let config = getConfig() else { return }
        if let userActivity = userActivity {
            config.userActivity = userActivity
        }
        if let openUrl = openUrl {
            config.openUrl = openUrl
        }
        Singular.start(config)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
            guard let config = getConfig() else { return }
            config.userActivity = userActivity
            
            // Initialize Singular SDK
            Singular.start(config)
        }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let config = getConfig() else { return }
        
        // Capture the OpenURL and store in UserDefaults
        let openurlString = URLContexts.first?.url
        UserDefaults.standard.set(openurlString?.absoluteString, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(openurlString?.absoluteString, forKey: Constants.OPENURL)
            
        if let url = URLContexts.first?.url {
            config.openUrl = url
        }
            
        // Initialize Singular SDK
        Singular.start(config)
        
        // Redirect to the DeeplinkController if Non-Singular deeplink exists
        if (!Utils.isEmptyOrNull(text: openurlString?.absoluteString)) {
            DispatchQueue.main.async(execute: { [self] in
                let tabBar = window?.rootViewController as? TabController
                tabBar?.openedWithDeeplink()
            })
        }
    }
    
    // MARK: - Singular Configuration
    private func getConfig() -> SingularConfig? {
        // Create config with your credentials
        guard let config = SingularConfig(
            apiKey: Constants.APIKEY,
            andSecret: Constants.SECRET) else {
            return nil
        }
        
        // OPTIONAL: Wait for Apple Tracking Transparency consent
        // Remove this line if NOT using App Tracking Transparency
        config.waitForTrackingAuthorizationWithTimeoutInterval = 300
        
        // OPTIONAL: Support custom ESP domains for deep links
        config.espDomains = ["links.your-domain.com"]
        
        // OPTIONAL: Handle deep links
        config.singularLinksHandler = { params in
            if let params = params {
              self.handleDeeplink(params)
            }
        }
        
        // OPTIONAL: Device Attribution Info Callback --- This is a BETA feature
        config.deviceAttributionCallback = { attributionInfo in
            self.attributionInfoHandler(attributionInfo)
        }
        
        // OPTIONAL: Set Global Properties with 3rd-Party Identifiers
        // Using Singular Global Properties feature to capture third party identifiers
        let thirdPartyKey = "anonymousID"
        let thirdPartyID = "2ed20738-059d-42b5-ab80-5aa0c530e3e1"
        config.setGlobalProperty(thirdPartyKey, withValue: thirdPartyID, overrideExisting: true)
        
        // OPTIONAL: Set Session Timeout to 2min
        Singular.setSessionTimeout(120)
        
        return config
    }

    // MARK: - OPTIONAL: Deep link handler implementation
    private func handleDeeplink(_ params: SingularLinkParams) {
        // Guard clause: Exit if no deep link provided
        guard let deeplink = params.getDeepLink() else {
          return
        }
                
        // Extract deep link parameters
        let passthrough = params.getPassthrough()
        let isDeferredDeeplink = params.isDeferred()
        let urlParams = params.getUrlParameters()
        
        #if DEBUG
        // Debug logging only - stripped from production builds
        print(Date(), "-- Singular deeplink: \(String(describing: deeplink))")
        print(Date(), "-- Singular passthrough: \(String(describing: passthrough))")
        print(Date(), "-- Singular isDeferred: \(String(describing: isDeferredDeeplink))")
        print(Date(), "-- Singular urlParams: \(String(describing: urlParams))")
        #endif
        
        // TODO: Navigate to appropriate screen based on deep link
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
    
    private func attributionInfoHandler(_ attributionInfo: [AnyHashable: Any]?) {
        guard let attributionInfo = attributionInfo else {
            return
        }
        #if DEBUG
        print(Date(), "-- Singular Attribution Info: \(attributionInfo)")
        #endif
        
        // TODO: Navigate to appropriate screen based on attribution data
        // Add Attribution handling code here
    }
        
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print(Date(), "-- sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print(Date(), "-- sceneDidBecomeActive")
        
//        let url = URL(string: "https://app.thebiblechat.com/Eryen/4r7h2/r_47647a6860")!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let httpResponse = response as? HTTPURLResponse {
//                // Access response headers, status code, etc.
//                print("Status: \(httpResponse.statusCode)")
//                print("Headers: \(httpResponse.allHeaderFields)")
//            }
//            
//            if let data = data {
//                // Process response body
//                print("Body: \(String(data: data, encoding: .utf8) ?? "")")
//            }
//        }
//        task.resume()
        
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


