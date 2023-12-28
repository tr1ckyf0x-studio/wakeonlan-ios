//
//  FirebaseAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 01.11.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import FirebaseCore
import UIKit

final class FirebaseAppDelegatePlugin: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
