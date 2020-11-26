//
//  DDLogAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 18.10.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

final class DDLogAppDelegatePlugin: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        DDLog.add(DDOSLogger.sharedInstance)
        return true
    }
}
