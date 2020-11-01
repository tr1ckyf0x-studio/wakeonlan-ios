//
//  FirebaseAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 01.11.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import Firebase

class FirebaseAppDelegatePlugin: NSObject, UIApplicationDelegate {
    // swiftlint:disable line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
