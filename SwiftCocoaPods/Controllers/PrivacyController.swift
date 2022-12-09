//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class PrivacyController: UIViewController {
    
    @IBOutlet weak var gdpr: UISwitch!
    @IBOutlet weak var limited_data_sharing: UISwitch!
    @IBOutlet weak var idfaValue: UILabel!
    @IBOutlet weak var idfvValue: UILabel!
    @IBOutlet weak var shareDeviceInfo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(Date(), "-- PrivacyController - viewWillAppear")
        
        // Displaying the Identifiers on the PrivacyController
        idfvValue.text = UserDefaults.standard.string(forKey: "idfv")
        idfaValue.text = UserDefaults.standard.string(forKey: "idfa")
    }
    
    @IBAction func gdprToggled(_ sender: Any) {
        if (gdpr.isOn){
            // If User toggles the GDPR Opt Out to ON, we want to disable the Singular SDK to prohibit Tracking
            Singular.event("GDPR_OptOut")
            
            Singular.stopAllTracking() // This disables the Singular SDK
            
            print(Date(), "-- GDPR Tracking OptOut - Tracking Stopped")
            Utils.displayMessage(message: "GDPR Tracking OptOut - Tracking Stopped", withView: self)
            
        } else {
            // If User toggles the GDPR Opt Out to OFF, we want to check the tracking state, and re-enable Tracking
            if (Singular.isAllTrackingStopped()) {
                
                Singular.resumeAllTracking() // This enables the Singular SDK
                Singular.trackingOptIn() // This notifies Singular the User is Opt'ing in for Tracking
                
                Singular.event("GDPR_OptIn")
                
                print(Date(), "-- GDPR Tracking OptIn - Tracking Started")
                Utils.displayMessage(message: "GDPR Tracking OptIn - Tracking Started", withView: self)
            }
        }
    }
    
    @IBAction func limitedDataSharingOptionToggled(_ sender: Any) {
        if (limited_data_sharing.isOn){
            // If User toggles the CCPA Limited Data Sharing Opt Out to ON, we want to disable datasharing for this device
            Singular.limitDataSharing(true) // This will limit data sharing to ad network partners
            Singular.event("LimitedDataSharing_OptIn")
            
            print(Date(), "-- Limited Data Sharing OptIn - Tracking remains enabled but limited data will not be shared with Networks")
            Utils.displayMessage(message: "Limited Data Sharing OptIn - Tracking remains enabled but limited data will not be shared with Networks", withView: self)
            
        } else {
            // If User toggles the CCPA Limited Data Sharing Opt Out to OFF, we want to re-enable datasharing for this device
            Singular.limitDataSharing(false) // This will reactivate data sharing to ad network partners
            Singular.event("LimitedDataSharing_OptOut")
            
            print(Date(), "-- Limited Data Sharing OptOut - All Data will be shared with networks")
            Utils.displayMessage(message: "Limited Data Sharing OptOut - All Data will be shared with networks", withView: self)
        }
    }
    
    @IBAction func shareDeviceInfo(_ sender: Any) {
        let IDFV = UserDefaults.standard.string(forKey: "idfv")
        let IDFA = UserDefaults.standard.string(forKey: "idfa")
        if (IDFV != nil || IDFA != nil){
            print(Date(), "-- Sharing Device Info")
            let items = [
                "Device Identifiers:\n\nIDFV: \(String(describing: IDFV))\nIDFA: \(String(describing: IDFA))"
            ]
            let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            shareController.modalPresentationStyle = .popover
            DispatchQueue.main.async(execute: { [self] in
                present(shareController, animated: true)
            })
        }
    }
    
}
