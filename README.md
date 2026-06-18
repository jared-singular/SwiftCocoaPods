# SwiftCocoaPods

Reference iOS sample for the [Singular SDK](https://github.com/singular-labs/Singular-iOS-SDK). Built with UIKit + storyboards and intended to show, side by side, how to wire up:

- SDK initialization in `SceneDelegate`
- App Tracking Transparency (ATT) with proper IDFA capture
- Standard and custom event tracking
- Standard and custom revenue events
- Singular Links deep linking (deferred + standard) and custom URL scheme handling
- Custom user IDs (login flow)
- GDPR / CCPA opt-outs and `limitDataSharing` / `setLimitAdvertisingIdentifiers`
- Referrer short-link generation
- Uninstall tracking via APNs token

## Requirements

| | |
|---|---|
| Xcode | 16 or later |
| iOS deployment target | 16.0+ |
| Singular SDK | 12.12.x |
| Dependency manager | CocoaPods |

## Setup

1. **Install pods**
   ```bash
   pod install
   ```
2. **Create your local secrets file**
   ```bash
   cp SwiftCocoaPods/Secrets.example.xcconfig Secrets.xcconfig
   ```
   Open `Secrets.xcconfig` (at the repo root) and replace the placeholders with your own Singular API key and secret from the Singular dashboard. This file is gitignored.
3. **Wire the xcconfig** (one-time, in Xcode)
   - Open `SwiftCocoaPods.xcworkspace`
   - Select the `SwiftCocoaPods` **project** (not the target) in the navigator
   - In the **Info** tab, expand **Configurations**
   - For each configuration (Debug, Release), set the **SwiftCocoaPods target** base configuration to `Secrets.xcconfig`
4. **Wire the privacy manifest** (one-time, in Xcode)
   - Drag `SwiftCocoaPods/PrivacyInfo.xcprivacy` into the project navigator
   - Check the `SwiftCocoaPods` target under **Add to targets**
5. **Build and run** on a device (ATT and IDFA do not exercise on the simulator).

> **Note:** This sample is intentionally pinned to CocoaPods. For a Swift Package Manager integration example, see the companion sample [Singular-iOS-SDK GitHub repo](https://github.com/singular-labs/Singular-iOS-SDK) or Singular's [iOS SDK integration docs](https://support.singular.net/hc/en-us/articles/360037950591).

## Project layout

```
.
├── Secrets.xcconfig             # Local-only, gitignored. Holds your API key + secret
└── SwiftCocoaPods/
    ├── Secrets.example.xcconfig # Template — copy to /Secrets.xcconfig at the repo root
    ├── AppDelegate.swift        # Lifecycle hooks; defers init to SceneDelegate
    ├── SceneDelegate.swift      # Singular.start, deep link routing, ATT
    ├── Constants.swift          # Reads API key/secret from Info.plist (xcconfig)
    ├── Utils.swift              # ATT request + IDFA/IDFV capture
    ├── Info.plist               # Includes NSUserTrackingUsageDescription
    ├── PrivacyInfo.xcprivacy    # Required privacy manifest
    └── Controllers/
        ├── TabController.swift
        ├── PrivacyController.swift
        ├── SignInController.swift
        ├── RevenueController.swift
        ├── EventsController.swift
        ├── DeeplinkController.swift
        └── ReferrerController.swift
```

## Resources

- [Singular iOS SDK docs](https://support.singular.net/hc/en-us/articles/360037950591)
- [Singular iOS SDK GitHub](https://github.com/singular-labs/Singular-iOS-SDK)
- [Apple ATT documentation](https://developer.apple.com/documentation/apptrackingtransparency)
- [Apple Privacy Manifest reference](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)
