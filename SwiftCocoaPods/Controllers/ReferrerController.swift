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
        print(Date(), "-- ReferrerController - viewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(Date(), "-- ReferrerController - viewDidDisappear")
        // Clear the Referrer Form data so they are not used again.
        referrerIDField.text = nil;
        referrerNameField.text = nil;
    }
    
    @IBAction func sharedClicked(_ sender: Any) {
        print(Date(), "-- ReferrerController - sharedClicked")
        
        // Define variables for the Referral Short Link:
        
        // Add your Singular tracking link to be used as a base link:
        let referrerBaseLink = "https://joswiftpods.sng.link/Cje1e/bb8p?_dl=joswiftpods%3A%2F%2Fmy_default_deeplink&_smtype=3";
        
        // Add your Referrer ID and Name
        let referrerID = referrerIDField.text;
        let referrerName = referrerNameField.text;
        
        // Customize any Passthrough Parameters
        let passthroughParams = [
            "channel": "sms"
        ]
        
        // Call the ReferrerShortLink Method to get your shortlink to share on Social
        Singular.createReferrerShortLink(referrerBaseLink, referrerName: referrerName, referrerId: referrerID, passthroughParams: passthroughParams, completionHandler: {(shortLink, error) in
            if error != nil {
                // Logic to retry/abort/modify the params passed to the function, based on the cause of the error
                print(Date(), "-- Error: \(String(describing: error))")
            }
            
            if (shortLink != nil || shortLink != "") {
                print(Date(), "-- Short Link Received: \(String(describing: shortLink))")
                
                // Add your share logic here:
                
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
