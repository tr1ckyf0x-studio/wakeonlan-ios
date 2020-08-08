//
//  AddHostTableManagerDelegate.swift
//  Wake on LAN
//
//  Created by 18250161 on 19.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

protocol AddHostTableManagerDelegate: class {
    func tableManagerDidTapDeviceIconCell(_ manager: AddHostTableManager,
                                          _ model: IconModel)
}
