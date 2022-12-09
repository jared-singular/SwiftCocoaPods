//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class DeeplinkController: UIViewController {

    @IBOutlet weak var deeplinkField: UILabel!
    @IBOutlet weak var passthroughField: UILabel!
    @IBOutlet weak var isDeferredField: UILabel!
    @IBOutlet weak var openURLField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Date(), "-- DeeplinkController - viewWillAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(Date(), "-- DeeplinkController - viewWillAppear")
        
        // Display deeplink data from UserDefaults
        deeplinkField.text = UserDefaults.standard.string(forKey: Constants.DEEPLINK)
        passthroughField.text = UserDefaults.standard.string(forKey: Constants.PASSTHROUGH)
        isDeferredField.text = UserDefaults.standard.string(forKey: Constants.IS_DEFERRED)
        openURLField.text = UserDefaults.standard.string(forKey: Constants.OPENURL)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(Date(), "-- viewDidDisappear")
        print(Date(), "-- Clearing Link Data")
        
        // Clear the deeplink data from UserDefaults
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.IS_DEFERRED)
        UserDefaults.standard.set(nil, forKey: Constants.OPENURL)
        
    }
    
}
