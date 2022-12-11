//
//  ViewController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit
import Singular

class EventsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Date(), "-- EventsController - viewDidLoad")
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_TYPE] = "EventsController"
        dic[ATTRIBUTE_SNG_ATTR_CONTENT_ID] = "3"
        dic[ATTRIBUTE_SNG_ATTR_CONTENT] = "Event Method Buttons"
        Singular.event(EVENT_SNG_CONTENT_VIEW, withArgs: dic)
    }
    
    @IBAction func sng_level_achievedClicked(_ sender: Any) {
        print(Date(), "-- sng_level_achieved Button Clicked")
        
        // Send a Standard Event to Singular without Attributes
        Singular.event(EVENT_SNG_LEVEL_ACHIEVED)
    }
    
    
    @IBAction func sng_add_to_cartClicked(_ sender: Any) {
        print(Date(), "-- sng_add_to_cart Button Clicked")
        
        // Send a Standard Event to Singular with Attributes
        // Define Attributes:
        var dic: [AnyHashable : Any] = [:]
        dic[ATTRIBUTE_SNG_ATTR_ITEM_DESCRIPTION] = "100% Organic Cotton Mixed Plaid Flannel Shirt"
        dic[ATTRIBUTE_SNG_ATTR_ITEM_PRICE] = "$69.95"
        dic[ATTRIBUTE_SNG_ATTR_RATING] = "5 Star"
        dic[ATTRIBUTE_SNG_ATTR_SEARCH_STRING] = "Flannel Shirt"
        dic[ATTRIBUTE_SNG_ATTR_DEEP_LINK] = "https://www.gap.com/browse/product.do?pid=488359012&cid=11900&pcid=11900&vid=1&cpos=5&cexp=2859&kcid=CategoryIDs%3D11900&cvar=25416&ctype=Listing&cpid=res22120510129881629780811#pdp-page-content"
        
        // Send the Event
        Singular.event(EVENT_SNG_ADD_TO_CART, withArgs: dic)
    }
    
    
    @IBAction func customEventClicked(_ sender: Any) {
        print(Date(), "-- customEvent Button Clicked")
        
        // Send a Standard Event to Singular with Attributes
        // Define an Event Name: NOTE: Event names must be <= 32 characters
        let customEventName = "my_custom_event_name"
        
        // Define Attributes:
        var customArgs: [AnyHashable : Any] = [:]
        customArgs["key1"] = "Value1"
        customArgs["key2"] = "Value2"
        
        // Send the Event
        Singular.event(customEventName, withArgs: customArgs)
    }
    
}
