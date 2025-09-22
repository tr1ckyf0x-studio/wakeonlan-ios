//
//  Validator.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 17.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

protocol Validator {
    associatedtype Value

    func validate(value: Value) -> Bool
}
