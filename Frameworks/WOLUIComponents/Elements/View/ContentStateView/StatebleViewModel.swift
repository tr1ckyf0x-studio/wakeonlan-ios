//
//  StateableViewModel.swift
//  Wake on LAN
//
//  Created by Dmitry on 16.11.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import UIKit

public struct StateableViewModel {
    public let title: String?
    public let image: UIImage?
    public let backgroundColor: UIColor?

    public init(title: String?, image: UIImage?, backgroundColor: UIColor?) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
    }
}
