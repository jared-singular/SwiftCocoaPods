//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonActionGetAtt(_ sender: UIButton) {
        print(Date(),"-- Asking for ATT Consent - Clicked!")
        Utils.requestTrackingAuthorization()
    }
    
    @IBAction func buttonActionSendEvent(_ sender: UIButton) {
        print(Date(),"-- Send Event - Clicked!")
        Singular.event("ButtonClick")
        Utils.displayMessage(title: "Testing", message: "Event sent", withView:self)
        
    }
    
}

