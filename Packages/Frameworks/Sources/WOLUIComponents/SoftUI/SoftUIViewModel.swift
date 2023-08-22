//
//  SoftUIViewModel.swift
//  WOLUIComponents
//
//  Created by Dmitry on 13.02.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit

public protocol DescribesSoftUIViewModel {
    /// View that appears for normal state
    var contentView: UIView? { get }
    /// View that appears for selected state
    var selectedContentView: UIView? { get }
    /// Affine transform that appears for selected state
    var selectedTransform: CGAffineTransform? { get }
}

public struct SoftUIViewModel: DescribesSoftUIViewModel {

    // MARK: - Properties

    public let contentView: UIView?
    public let selectedContentView: UIView?
    public let selectedTransform: CGAffineTransform?

    // MARK: - Init

    public init(
        contentView: UIView?,
        selectedContentView: UIView? = nil,
        selectedTransform: CGAffineTransform? = nil
    ) {
        self.contentView = contentView
        self.selectedContentView = selectedContentView
        self.selectedTransform = selectedTransform ?? Configuration.defaultSelectedTransform
    }

    // MARK: - Private

    private enum Configuration {
        static let defaultSelectedTransform: CGAffineTransform = .init(scaleX: 0.9, y: 0.9)
    }

}
