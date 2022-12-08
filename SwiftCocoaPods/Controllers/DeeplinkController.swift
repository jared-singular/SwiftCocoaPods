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
        // Do any additional setup after loading the view.
        print("DeeplinkController - viewWillAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("DeeplinkController - viewWillAppear")
        // Display deeplink data
        deeplinkField.text = UserDefaults.standard.string(forKey: Constants.DEEPLINK)
        passthroughField.text = UserDefaults.standard.string(forKey: Constants.PASSTHROUGH)
        isDeferredField.text = UserDefaults.standard.string(forKey: Constants.IS_DEFERRED)
        openURLField.text = UserDefaults.standard.string(forKey: Constants.OPENURL)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        print("Clearing Link Data")
        
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.DEEPLINK)
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.PASSTHROUGH)
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.IS_DEFERRED)
        UserDefaults.standard.set(Constants.NODEEPLINKTEXT, forKey: Constants.OPENURL)
        
    }
    
}
