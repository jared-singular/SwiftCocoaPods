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
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_TYPE] = "DeeplinkController"
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_ID] = "4"
        dic[ATTRIBUTE_SNG_ATTR_CONTENT] = "Deeplink and Open URL Details"
        Singular.event(EVENT_SNG_CONTENT_VIEW, withArgs: dic)
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
