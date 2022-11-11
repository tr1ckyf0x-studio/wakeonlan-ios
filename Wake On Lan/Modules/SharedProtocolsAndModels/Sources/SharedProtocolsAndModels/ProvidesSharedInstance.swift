//
//  FormValidable.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.11.2022.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

public protocol ProvidesSharedInstance: AnyObject {
    static var shared: Self { get }
}

public protocol ProvidesWeakSharedInstanceTrait: ProvidesSharedInstance {
    static var weakSharedInstance: Self? { get set }

    init()
}

extension ProvidesWeakSharedInstanceTrait {
    public static var shared: Self {
        if let weakSharedInstance {
            return weakSharedInstance
        }
        let instance = Self()
        weakSharedInstance = instance
        return instance
    }
}
