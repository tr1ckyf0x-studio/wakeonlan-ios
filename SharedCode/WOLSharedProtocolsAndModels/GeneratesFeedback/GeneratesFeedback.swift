//
//  GeneratesFeedback.swift
//  
//
//  Created by Dmitry on 27.03.2022.
//

import UIKit

// MARK: - GeneratesNotificationFeedback

public protocol GeneratesNotificationFeedback {
    /// Generates notification feedback
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType)
}

extension UINotificationFeedbackGenerator: GeneratesNotificationFeedback { }

// MARK: - GeneratesImpactFeedback

public protocol GeneratesImpactFeedback {
    /// Generates impact feedback
    func impactOccurred()
}

extension UIImpactFeedbackGenerator: GeneratesImpactFeedback { }
