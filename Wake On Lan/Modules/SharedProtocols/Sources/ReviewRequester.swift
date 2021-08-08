//
//  RateApplicationManager.swift
//  AboutScreen
//
//  Created by Dmitry on 04.08.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation
import StoreKit

public protocol RequestsReview {
    /// Requests application review
    static func requestReview()
}

extension SKStoreReviewController: RequestsReview { }
