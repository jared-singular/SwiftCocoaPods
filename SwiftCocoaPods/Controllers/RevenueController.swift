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
        print(Date(), "-- RevenueController - viewDidLoad")
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_TYPE] = "RevenueController"
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_ID] = "2"
        dic[ATTRIBUTE_SNG_ATTR_CONTENT] = "Revenue Method Buttons"
        Singular.event(EVENT_SNG_CONTENT_VIEW, withArgs: dic)
    }
    
    
    @IBAction func iapCompletedMethodClicked(_ sender: Any) {
        print(Date(), "-- iapCompletedMethod Button Clicked")
        
        // *** Get the SKPaymentTransaction* transaction object ***
        //let transaction:SKPaymentTransaction = ...

        // Send a transaction event to Singular without a custom event name
        //Singular.iapComplete(transaction)

        // Send a transaction event to Singular with a custom event name
        //Singular.iapComplete(transaction, withName:"MyCustomRevenue")
        
        Utils.displayMessage(message: "Requires SKPaymentTransaction Data and this app can not simulate the event. Check RevenueController and Help Center for documentation.", withView: self)
        
        // Sending a Custom Revenue Event only for notification purposes that the button was pressed.
        Singular.customRevenue("Needs_SKPaymentTransaction", currency: "USD", amount: 0.99)
    }
    
    
    @IBAction func revenueMethodClicked(_ sender: Any) {
        print(Date(), "-- revenueMethod Button Clicked")
        
        // Revenue with no product details
        Singular.revenue("USD",amount:1.99)
        
        // Send a Revenue Event with product details using the Revenue Method
        Singular.revenue("EUR",amount:5.00, productSKU:"SKU1928375",
        productName:"Reservation Fee",productCategory:"Fee",
        productQuantity:1, productPrice:5.00)
        
        // Send a Revenue Event with attributes in a dictionary
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_ITEM_DESCRIPTION] = "100% Organic Cotton Mixed Plaid Flannel Shirt"
        dic[ATTRIBUTE_SNG_ATTR_ITEM_PRICE] = "$69.95"
        dic[ATTRIBUTE_SNG_ATTR_RATING] = "5 Star"
        dic[ATTRIBUTE_SNG_ATTR_SEARCH_STRING] = "Flannel Shirt"
        Singular.revenue("USD", amount: 19.95, withAttributes: dic)
    }
    
    
    @IBAction func customRevenueMethodClicked(_ sender: Any) {
        print(Date(), "-- customRevenueMethod Button Clicked")
        
        // Send a Custom Revenue Event with a custom name and no product details
        Singular.customRevenue("CustomRevenueNoArgs", currency:"USD",
        amount:1.99)
        
        // Send a Custom Revenue Event with product details using the Revenue Method
        Singular.customRevenue("CustomRevenueWithArgs", currency:"EUR",
        amount:5.00, productSKU:"SKU1928375",
        productName:"Reservation Fee", productCategory:"Fee",
        productQuantity:1, productPrice:5.00)
        
        // Send a Custom Revenue Event with attributes in a dictionary
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_ITEM_DESCRIPTION] = "100% Organic Cotton Mixed Plaid Flannel Shirt"
        dic[ATTRIBUTE_SNG_ATTR_ITEM_PRICE] = "$69.95"
        dic[ATTRIBUTE_SNG_ATTR_RATING] = "5 Star"
        dic[ATTRIBUTE_SNG_ATTR_SEARCH_STRING] = "Flannel Shirt"
        Singular.customRevenue("CustomRevenueWithArgsDic", currency: "USD", amount: 44.99, withAttributes: dic)
    }
    
}
