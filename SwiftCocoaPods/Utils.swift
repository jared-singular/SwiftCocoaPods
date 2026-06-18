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

    static func isEmptyOrNull(text: String?) -> Bool {
        guard let text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return true
        }
        return false
    }

    /// Stores IDFV immediately and requests ATT. IDFA is only captured inside the
    /// completion handler when the user grants tracking authorization — otherwise
    /// `advertisingIdentifier` returns all-zeros and is not useful to persist.
    /// Singular auto-detects the ATT status; this helper just mirrors values to
    /// UserDefaults so the Privacy tab can display them.
    static func requestTrackingAuthorization() {
        let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
        UserDefaults.standard.set(idfv, forKey: "idfv")

        guard #available(iOS 14, *) else { return }

        ATTrackingManager.requestTrackingAuthorization { status in
            print(Date(), "-- ATT:", status.rawValue)

            let idfa: String
            switch status {
            case .authorized:
                idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            case .denied, .restricted, .notDetermined:
                idfa = ""
            @unknown default:
                idfa = ""
            }
            UserDefaults.standard.set(idfa, forKey: "idfa")
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
