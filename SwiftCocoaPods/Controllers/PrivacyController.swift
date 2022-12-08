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
        // Do any additional setup after loading the view.
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("PrivacyController - viewWillAppear")
        idfvValue.text = UserDefaults.standard.string(forKey: "idfv")
        idfaValue.text = UserDefaults.standard.string(forKey: "idfa")
    }
    
    @IBAction func gdprToggled(_ sender: Any) {
        if (gdpr.isOn){
            Singular.event("GDPR_OptOut")
            Singular.stopAllTracking()
            print("GDPR Tracking OptOut - Tracking Stopped")
            Utils.displayMessage(message: "GDPR Tracking OptOut - Tracking Stopped", withView: self)
            
        } else {
            if (Singular.isAllTrackingStopped()){
                Singular.resumeAllTracking()
                Singular.trackingOptIn()
                Singular.event("GDPR_OptIn")
                
                //Logging for testing
                print("GDPR Tracking OptIn - Tracking Started")
                Utils.displayMessage(message: "GDPR Tracking OptIn - Tracking Started", withView: self)
            }
        }
    }
    
    @IBAction func limitedDataSharingOptionToggled(_ sender: Any) {
        if (limited_data_sharing.isOn){
            Singular.limitDataSharing(true)
            Singular.event("LimitedDataSharing_OptIn")
            
            //Logging for testing
            print("Limited Data Sharing OptIn - Tracking remains enabled but limited data will not be shared with Networks")
            Utils.displayMessage(message: "Limited Data Sharing OptIn - Tracking remains enabled but limited data will not be shared with Networks", withView: self)
            
        } else {
            Singular.limitDataSharing(false)
            Singular.event("LimitedDataSharing_OptOut")
            
            //Logging for testing
            print("Limited Data Sharing OptOut - All Data will be shared with networks")
            Utils.displayMessage(message: "Limited Data Sharing OptOut - All Data will be shared with networks", withView: self)
        }
        
    }
    
    @IBAction func shareDeviceInfo(_ sender: Any) {
        let IDFV = UserDefaults.standard.string(forKey: "idfv")
        let IDFA = UserDefaults.standard.string(forKey: "idfa")
        if (IDFV != nil || IDFA != nil){
            print("Sharing Device Info")
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
