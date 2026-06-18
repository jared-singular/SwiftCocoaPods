//
//  TabController.swift
//  SwiftCocoaPods
//
//  Created by Jared Ornstead on 11/24/22.
//

import UIKit

class TabController: UITabBarController {

    /// Each case's `rawValue` matches the storyboard tab order. If you reorder
    /// tabs in Main.storyboard, update these indices to match — or, better,
    /// assign each tab a stable `tag` in IB and switch this to a tag lookup.
    enum Tab: Int {
        case privacy = 0
        case signIn = 1
        case revenue = 2
        case events = 3
        case deeplink = 4
        case referrer = 5
    }

    func openedWithDeeplink() {
        select(.deeplink)
    }

    func select(_ tab: Tab) {
        selectedIndex = tab.rawValue
    }

    // Dismiss the keyboard on taps outside text fields.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
