//
//  SceneDelegate.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var didRequestATT = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Capture any launch-time deep link sources before Singular.start so they
        // can be passed into the config (this is how Singular resolves the inbound
        // link when not using its swizzling support).
        let userActivity = connectionOptions.userActivities.first
        let openUrl = connectionOptions.urlContexts.first?.url

        #if DEBUG
        print("[SWIZZLE CHECK] UserActivity captured:", userActivity?.webpageURL?.absoluteString ?? "none")
        print("[SWIZZLE CHECK] URL Context captured:", openUrl?.absoluteString ?? "none")
        print("IDFV:", UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        #endif

        guard let windowScene = scene as? UIWindowScene else { return }

        // Capture IDFV and seed the IDFA placeholder before the UI loads so the
        // Privacy tab shows useful state on its first render. ATT itself is
        // requested later from sceneDidBecomeActive (the OS only presents the
        // prompt once the app is in the .active state).
        Utils.captureDeviceIdentifiers()

        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rootVC = storyboard.instantiateInitialViewController() else { return }
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()

        guard let config = getConfig() else { return }
        if let userActivity { config.userActivity = userActivity }
        if let openUrl { config.openUrl = openUrl }

        // Persist the raw inbound URL for the Deeplink tab to display.
        // Universal Links (Singular tracking links) arrive via userActivity;
        // custom URL schemes arrive via urlContexts.
        if let webpageURL = userActivity?.webpageURL {
            UserDefaults.standard.set(webpageURL.absoluteString, forKey: Constants.OPENURL)
        } else if let openUrl {
            UserDefaults.standard.set(openUrl.absoluteString, forKey: Constants.OPENURL)
        }

        Singular.start(config)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let config = getConfig() else { return }
        config.userActivity = userActivity

        // Persist the inbound Universal Link URL so the Deeplink tab can show it.
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let webpageURL = userActivity.webpageURL {
            UserDefaults.standard.set(webpageURL.absoluteString, forKey: Constants.OPENURL)
        }

        Singular.start(config)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let config = getConfig() else { return }

        let openurlString = URLContexts.first?.url
        UserDefaults.standard.set(openurlString?.absoluteString, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(openurlString?.absoluteString, forKey: Constants.OPENURL)

        if let url = URLContexts.first?.url {
            config.openUrl = url
        }

        Singular.start(config)

        // Route to the Deeplink tab if a non-Singular URL opened the app.
        if !Utils.isEmptyOrNull(text: openurlString?.absoluteString) {
            DispatchQueue.main.async { [weak self] in
                (self?.window?.rootViewController as? TabController)?.openedWithDeeplink()
            }
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print(Date(), "-- sceneDidBecomeActive")
        // ATT must be requested while the application is in the .active state.
        // Calling in the same runloop as sceneDidBecomeActive can return
        // .notDetermined immediately without presenting the prompt because the
        // app state hasn't fully settled yet. A 1s defer is the smallest reliable
        // workaround. Fire once per session.
        //
        // BEST PRACTICE FOR PRODUCTION APPS: Do not request ATT on first launch.
        // Apple's HIG and opt-in conversion data both favor a contextual prompt
        // shown after the user has seen value in the app (post-onboarding, after
        // a custom pre-prompt screen that explains why tracking helps them).
        // A well-timed prompt with a pre-prompt typically lifts opt-in rates 2-3x
        // vs. a cold first-launch prompt. This sample fires it eagerly to keep
        // the SDK integration easy to read — not because eager-on-launch is the
        // right UX choice.
        guard !didRequestATT else { return }
        didRequestATT = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Utils.requestTrackingAuthorization()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { print(Date(), "-- sceneDidDisconnect") }
    func sceneWillResignActive(_ scene: UIScene) { print(Date(), "-- sceneWillResignActive") }
    func sceneWillEnterForeground(_ scene: UIScene) { print(Date(), "-- sceneWillEnterForeground") }
    func sceneDidEnterBackground(_ scene: UIScene) { print(Date(), "-- sceneDidEnterBackground") }

    // MARK: - Singular Configuration

    private func getConfig() -> SingularConfig? {
        guard let config = SingularConfig(
            apiKey: Constants.APIKEY,
            andSecret: Constants.SECRET
        ) else {
            return nil
        }

        // Give the user up to 5 minutes to respond to the ATT prompt before
        // Singular sends its first session event. Adjust or remove if you are
        // not using App Tracking Transparency.
        config.waitForTrackingAuthorizationWithTimeoutInterval = 300

        // OPTIONAL: Custom ESP domains used for email/SMS deep links. Replace
        // or remove. Left commented out to avoid shipping an obviously fake
        // value in the sample.
        // config.espDomains = ["links.your-domain.com"]

        // OPTIONAL: Singular Links deep-link handler.
        config.singularLinksHandler = { [weak self] params in
            guard let self, let params else { return }
            self.handleDeeplink(params)
        }

        // OPTIONAL: Device-attribution callback (BETA). Fires once per install
        // when Singular resolves the attribution. Use this to personalize
        // first-run UX for paid installs (e.g. show campaign-specific welcome
        // content), tag the user for cohort routing, or forward the install
        // source to downstream analytics.
        config.deviceAttributionCallback = { [weak self] attributionData in
            self?.attributionInfoHandler(attributionData)
        }

        // OPTIONAL: Global properties forwarded with every event. Use this to
        // attach third-party identifiers (e.g. your CDP or analytics anonymous ID).
        config.setGlobalProperty(
            "anonymousID",
            withValue: "2ed20738-059d-42b5-ab80-5aa0c530e3e1",
            overrideExisting: true
        )
        
        // OPTIONAL: Singular Device ID (SDID) received callback. Singular emits
        // an SDID for Enterprise customers who have it enabled. The callback
        // delivers the value as `String?`, so unwrap before logging or storing.
        config.sdidReceivedHandler = { sdid in
            guard let sdid else { return }
            print(Date(), "-- SDID received:", sdid)
            UserDefaults.standard.set(sdid, forKey: Constants.SDID)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Utils.identifiersDidUpdate, object: nil)
            }
        }

        // OPTIONAL: Session timeout (default is 60s). 120s here for demo purposes.
        Singular.setSessionTimeout(120)

        return config
    }

    // MARK: - Deep link handling

    private func handleDeeplink(_ params: SingularLinkParams) {
        guard let deeplink = params.getDeepLink() else { return }

        let passthrough = params.getPassthrough()
        let isDeferredDeeplink = params.isDeferred()
        let urlParams = params.getUrlParameters()

        #if DEBUG
        print(Date(), "-- Singular deeplink:", deeplink)
        print(Date(), "-- Singular passthrough:", String(describing: passthrough))
        print(Date(), "-- Singular isDeferred:", isDeferredDeeplink)
        print(Date(), "-- Singular urlParams:", String(describing: urlParams))
        #endif

        // TODO: Route to the right screen based on `deeplink`. For this sample
        // we mirror the values into UserDefaults so DeeplinkController can show them.
        UserDefaults.standard.set(deeplink, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(passthrough, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(isDeferredDeeplink, forKey: Constants.IS_DEFERRED)

        if !Utils.isEmptyOrNull(text: deeplink) {
            DispatchQueue.main.async { [weak self] in
                (self?.window?.rootViewController as? TabController)?.openedWithDeeplink()
            }
        }
    }

    private func attributionInfoHandler(_ attributionInfo: [AnyHashable: Any]?) {
        guard let attributionInfo else { return }

        let network = attributionInfo["network"] as? String
        let campaignId = attributionInfo["campaign_id"] as? String
        let campaignName = attributionInfo["campaign_name"] as? String
        let clickTimestamp = attributionInfo["click_timestamp"] as? NSNumber

        #if DEBUG
        print(Date(), "-- Singular Attribution Info:")
        print("  network:", network ?? "nil")
        print("  campaign_id:", campaignId ?? "nil")
        print("  campaign_name:", campaignName ?? "nil")
        print("  click_timestamp:", clickTimestamp ?? "nil")
        #endif

        // Persist attribution fields so downstream UI / analytics can react.
        UserDefaults.standard.set(network, forKey: Constants.ATTRIBUTION_NETWORK)
        UserDefaults.standard.set(campaignId, forKey: Constants.ATTRIBUTION_CAMPAIGN_ID)
        UserDefaults.standard.set(campaignName, forKey: Constants.ATTRIBUTION_CAMPAIGN_NAME)
        UserDefaults.standard.set(clickTimestamp, forKey: Constants.ATTRIBUTION_CLICK_TIMESTAMP)

        // Personalize first-run UX based on the campaign that drove the install.
        // The callback may fire on a background thread; UI work must hop to main.
        if let campaignName {
            DispatchQueue.main.async { [weak self] in
                self?.showCampaignSpecificContent(campaignName)
            }
        }
    }

    private func showCampaignSpecificContent(_ campaignName: String) {
        guard let rootVC = window?.rootViewController else { return }
        let alert = UIAlertController(
            title: "Welcome",
            message: "Install attributed to campaign: \"\(campaignName)\"",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        rootVC.present(alert, animated: true)
    }
}
