//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class RevenueController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("RevenueController - viewDidLoad")
    }
    
    
    @IBAction func iapCompletedMethodClicked(_ sender: Any) {
        print("iapCompletedMethod Button Clicked")
        
        // Get the SKPaymentTransaction* transaction object
        //let transaction:SKPaymentTransaction = ...

        // Send a transaction event to Singular
        //Singular.iapComplete(transaction)

        // Send a transaction event to Singular with a custom name for the event
        //Singular.iapComplete(transaction, withName:"MyCustomRevenue")
        Utils.displayMessage(message: "Requires SKPaymentTransaction Data and this app can not simulate the event. Check RevenueController and Help Center for documentation.", withView: self)
        
        // Sending Custom Revenue Event only for notification purposes
        Singular.customRevenue("Needs_SKPaymentTransaction", currency: "USD", amount: 0.99)
        
    }
    
    
    @IBAction func revenueMethodClicked(_ sender: Any) {
        print("revenueMethod Button Clicked")
        
        // Revenue with product details
        Singular.revenue("EUR",amount:5.00, productSKU:"SKU1928375",
        productName:"Reservation Fee",productCategory:"Fee",
        productQuantity:1, productPrice:5.00)
    }
    
    
    @IBAction func customRevenueMethodClicked(_ sender: Any) {
        print("customRevenueMethod Button Clicked")
        
        // Revenue with a custom name and product details
        Singular.customRevenue("MyCustomRevenue", currency:"EUR",
        amount:5.00, productSKU:"SKU1928375",
        productName:"Reservation Fee", productCategory:"Fee",
        productQuantity:1, productPrice:5.00)
    }
    
}
