//
//  Constants.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/28/22.
//

import Foundation

enum Constants {
    /// Singular API key, injected from `Secrets.xcconfig` via Info.plist at build time.
    /// See `Secrets.example.xcconfig` for setup.
    static let APIKEY: String = infoPlistValue(forKey: "SingularApiKey")

    /// Singular secret, injected from `Secrets.xcconfig` via Info.plist at build time.
    static let SECRET: String = infoPlistValue(forKey: "SingularSecret")

    static let DEEPLINK = "deeplink"
    static let PASSTHROUGH = "passthrough"
    static let IS_DEFERRED = "is_deferred"
    static let OPENURL = "openurl"

    static let NODEEPLINKTEXT = "App did not open with a deep link"
    static let NOTDEFERRED = "Not a deferred deep link"

    static let AWAITING_CONSENT = "Awaiting consent…"
    static let TRACKING_DECLINED = "Tracking declined"

    static let ATTRIBUTION_NETWORK = "attribution_network"
    static let ATTRIBUTION_CAMPAIGN_ID = "attribution_campaign_id"
    static let ATTRIBUTION_CAMPAIGN_NAME = "attribution_campaign_name"
    static let ATTRIBUTION_CLICK_TIMESTAMP = "attribution_click_timestamp"

    private static func infoPlistValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty,
              !value.hasPrefix("$(") else {
            assertionFailure("Missing or unresolved Info.plist value for key: \(key). Did you copy Secrets.example.xcconfig to Secrets.xcconfig and wire it as the target's base configuration?")
            return ""
        }
        return value
    }
}
