//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func openedWithDeeplink() {
        // Display the DeeplinkController
        self.selectedIndex = 4
    }
    
    // Minimizes the keyboard when it's not needed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
