//
//  RateApplicationManager.swift
//  AboutScreen
//
//  Created by Dmitry on 04.08.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation
import StoreKit

// TODO: Move to common framework

protocol RequestsReview {
    /// Requests application review
    func requestReview()
}

struct ReviewRequester: RequestsReview {
    func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
