//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class ReferrerController: UIViewController {

    @IBOutlet weak var referrerNameField: UITextField!
    @IBOutlet weak var referrerIDField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ReferrerController - viewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Clear the Referrer data so they are not used again.
        print("ReferrerController - viewDidDisappear")
        referrerIDField.text = nil;
        referrerNameField.text = nil;
    }
    
    @IBAction func sharedClicked(_ sender: Any) {
        print("ReferrerController - sharedClicked")
        // Define Parameters for Referral Link
        let referrerBaseLink = "https://joswiftpods.sng.link/Cje1e/bb8p?_dl=joswiftpods%3A%2F%2Fmy_default_deeplink&_smtype=3";
        let referrerID = referrerIDField.text;
        let referrerName = referrerNameField.text;
        let passthroughParams = [
            "channel": "sms"
        ]
        
        Singular.createReferrerShortLink(referrerBaseLink, referrerName: referrerName, referrerId: referrerID, passthroughParams: passthroughParams, completionHandler: {(shortLink, error) in
            if error != nil {
                // Logic to retry/abort/modify the params passed to the function, based on the cause of the error
                print("Error: \(String(describing: error))")
            }
            
            if (shortLink != nil || shortLink != "") {
                // Add your share logic here
                print("Short Link Received: \(String(describing: shortLink))")
                
                // Share Link to ShareController
                let items = ["Check out this new app: \(String(describing: shortLink))"]
                let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                shareController.modalPresentationStyle = .popover
                DispatchQueue.main.async(execute: { [self] in
                    present(shareController, animated: true)
                })
            }
        })
    }
    
    
    
    
    
}
