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
        // Do any additional setup after loading the view.
        print("SignInController - viewDidLoad")
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let userID = userIDField.text
        
        if (userID == nil || userID == ""){
            Utils.displayMessage(message: "Enter a UserID to simulate the login process!", withView: self)
        } else {
            print("Login Button Clicked")
            Singular.setCustomUserId(userID)
            Singular.event(EVENT_SNG_LOGIN)
            userIDField.text = nil;
            Utils.displayMessage(message: "Login Success!", withView: self)
        }
    }
    
}
