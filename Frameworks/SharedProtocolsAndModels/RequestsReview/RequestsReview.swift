//
//  RequestsReview.swift
//  SharedProtocolsAndModels
//
//  Created by Dmitry on 04.08.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import StoreKit

public protocol RequestsReview {
    /// Requests application review
    static func requestReview()
}

extension SKStoreReviewController: RequestsReview { }
