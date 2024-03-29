//
//  DDLogAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 18.10.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import UIKit

final class DDLogAppDelegatePlugin: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        DDLog.add(DDOSLogger.sharedInstance)
        return true
    }
}
