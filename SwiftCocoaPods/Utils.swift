//
//  Utils.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/28/22.
//

import Foundation
import UIKit
import AppTrackingTransparency

class Utils {
    
    static func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                // call requestTrackingAuthorizationWithCompletionHandler from ATTrackingManager to start the user consent process
                ATTrackingManager.requestTrackingAuthorization { status in
                    print(Date(),"-- ATT:",status)
                    // your authorization handler here
                    // note: the Singular SDK will automatically detect if authorization has been given and initialize itself
                }
            }
        }
    }
    
    static func displayMessage(title: String, message: String, withView view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
        }))
        view.present(alert, animated: true, completion: nil)
    }
}
