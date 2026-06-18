//
//  Utils.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/28/22.
//

import Foundation
import UIKit
import AppTrackingTransparency
import AdSupport

enum Utils {

    /// Posted whenever IDFV or IDFA values are written to UserDefaults. UI that
    /// displays these identifiers should observe this on the main queue and refresh.
    static let identifiersDidUpdate = Notification.Name("SwiftCocoaPods.identifiersDidUpdate")

    static func isEmptyOrNull(text: String?) -> Bool {
        guard let text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return true
        }
        return false
    }

    /// Captures IDFV (available immediately, no consent required) and seeds the
    /// IDFA slot with an "awaiting consent" placeholder so the Privacy tab can
    /// render a useful initial state before ATT resolves. Call from
    /// `SceneDelegate.willConnectTo` before the window is made key.
    static func captureDeviceIdentifiers() {
        let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
        UserDefaults.standard.set(idfv, forKey: "idfv")
        UserDefaults.standard.set(Constants.AWAITING_CONSENT, forKey: "idfa")
        NotificationCenter.default.post(name: identifiersDidUpdate, object: nil)
    }

    /// Requests ATT and updates the IDFA value in UserDefaults based on the result.
    /// IDFA is only captured when the user grants tracking authorization —
    /// `advertisingIdentifier` returns all-zeros otherwise and is not useful to persist.
    /// Singular auto-detects the ATT status; this helper just mirrors values to
    /// UserDefaults so the Privacy tab can display them.
    static func requestTrackingAuthorization() {
        guard #available(iOS 14, *) else { return }

        ATTrackingManager.requestTrackingAuthorization { status in
            print(Date(), "-- ATT:", status.rawValue)

            let idfa: String
            switch status {
            case .authorized:
                idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            case .denied, .restricted:
                idfa = Constants.TRACKING_DECLINED
            case .notDetermined:
                idfa = Constants.AWAITING_CONSENT
            @unknown default:
                idfa = Constants.TRACKING_DECLINED
            }
            UserDefaults.standard.set(idfa, forKey: "idfa")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: identifiersDidUpdate, object: nil)
            }
        }
    }

    static func displayMessage(message: String, withView view: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        view.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true)
        }
    }
}
