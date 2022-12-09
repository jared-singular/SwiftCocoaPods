//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class SignInController: UIViewController {

    @IBOutlet weak var userIDField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Date(), "-- SignInController - viewDidLoad")
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_ID] = "SignInController"
        Singular.event(EVENT_SNG_CONTENT_VIEW, withArgs: dic)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let userID = userIDField.text
        if (userID == nil || userID == ""){
            Utils.displayMessage(message: "Enter a UserID to simulate the login process!", withView: self)
        } else {
            print(Date(), "-- Login Button Clicked")
            
            // Set the User ID in Singular using the setCustomUserID Method
            Singular.setCustomUserId(userID)
            
            // Sending a Standard Event after setting the customUserID show the Custom User ID is inhereted.
            Singular.event(EVENT_SNG_LOGIN)
            
            userIDField.text = nil;
            Utils.displayMessage(message: "Login Success!", withView: self)
        }
    }
    
}
