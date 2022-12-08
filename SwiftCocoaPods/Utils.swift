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

class Utils {
    
    static func isEmptyOrNull(text: String?) -> Bool {
        if let text = text, text.count != 0, text.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
            return false
        }
        return true
    }
    
    static func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                // call requestTrackingAuthorizationWithCompletionHandler from ATTrackingManager to start the user consent process
                ATTrackingManager.requestTrackingAuthorization { status in
                    print(Date(),"-- ATT:",status)
                    // your authorization handler here
                    // note: the Singular SDK will automatically detect if authorization has been given and initialize itself
                }
                let IDFA = ASIdentifierManager().advertisingIdentifier.uuidString
                let IDFV = UIDevice().identifierForVendor!.uuidString
                UserDefaults.standard.set(IDFA, forKey: "idfa")
                UserDefaults.standard.set(IDFV, forKey: "idfv")
            }
        }
    }
    
    static func displayMessage(message: String, withView view:UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        view.present(alert, animated: true, completion: nil)
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
