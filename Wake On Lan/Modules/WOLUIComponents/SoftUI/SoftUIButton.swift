//
//  UIButton+SoftUI.swift
//  Wake on LAN
//
//  Created by Dmitry on 09.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

public final class SoftUIButton: UIButton, SoftUIRepresentable {

    // MARK: - Override

    override public var isHighlighted: Bool {
        didSet {
            pressed = isHighlighted ? true : false
        }
    }

    override public var isSelected: Bool {
        didSet {
            pressed = isSelected ? false : true
        }
    }

    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if roundShape { cornerRadius = bounds.height / 2 }
        addSoftUIEffectIfNeeded()
    }

    // MARK: - Properties

    var themeColor: UIColor

    var cornerRadius: CGFloat

    private var pressed: Bool = false {
        didSet {
            guard let shadowLayer = layer.sublayers?.first else { return }
            switch pressed {
            case true:
                layer.shadowOffset = CGSize(width: -2, height: -2)
                shadowLayer.shadowOffset = CGSize(width: 2, height: 2)
                contentEdgeInsets = .init(top: 2, left: 2, bottom: 0, right: 0)

            case false:
                layer.shadowOffset = CGSize(width: 2, height: 2)
                shadowLayer.shadowOffset = CGSize(width: -2, height: -2)
                contentEdgeInsets = .init(top: 0, left: 0, bottom: 2, right: 2)
            }
        }
    }

    private var roundShape: Bool = false

    // MARK: - Init

    public init(
        roundShape: Bool = false,
        cornerRadius: CGFloat = 15.0,
        themeColor: UIColor = R.color.soft() ?? UIColor()
    ) {
        self.roundShape = roundShape
        self.themeColor = themeColor
        self.cornerRadius = cornerRadius

        super.init(frame: .zero)
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
