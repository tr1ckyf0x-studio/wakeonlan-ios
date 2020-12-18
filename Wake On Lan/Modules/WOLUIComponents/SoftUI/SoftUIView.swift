//
//  UIView+SoftUI.swift
//  Wake on LAN
//
//  Created by Dmitry on 07.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

public final class SoftUIView: UIView, SoftUIRepresentable {

    // MARK: - Properties

    var themeColor: UIColor

    var cornerRadius: CGFloat

    // MARK: - Init

    public init(
        cornerRadius: CGFloat = 15.0,
        themeColor: UIColor = R.color.soft() ?? UIColor()
    ) {
        self.themeColor = themeColor
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        addSoftUIEffectIfNeeded()
    }

}
