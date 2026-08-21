//
//  IAPAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 21. 8. 2026..
//  Copyright © 2026 Vladislav Lisianskii. All rights reserved.
//

import UIKit

/// Keeps the StoreKit transaction observer registered for the whole process lifetime.
///
/// `IAPManager.shared` is a weak singleton, so without a strong reference held here the observer
/// would only exist while the Donate screen is on screen. Transactions delivered outside that window
/// — promoted App Store purchases, purchases interrupted by termination, "Ask to Buy" approvals —
/// would then never be finished and would stay pending in the payment queue forever.
final class IAPAppDelegatePlugin: NSObject, UIApplicationDelegate {
    // MARK: - Properties

    private var iapManager: ManagesIAP?

    // MARK: - UIApplicationDelegate

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        iapManager = IAPManager.shared
        return true
    }
}
