//
//  SoftUIProtocol.swift
//  Wake on LAN
//
//  Created by Dmitry on 10.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

protocol SoftUIRepresentable {

    var themeColor: UIColor { get }

    var cornerRadius: CGFloat { get }

    func addSoftUIEffectIfNeeded()

}

extension SoftUIRepresentable where Self: UIView {

    func addSoftUIEffectIfNeeded() {
        layer.addBottomRightEffect(cornerRadius: cornerRadius)
        let oldShadowLayer = layer.sublayers?.first {
            $0.name == Configuration.shadowLayerName
        }

        let newShadowLayer = { () -> CAShapeLayer in
            let layer = CAShapeLayer()
            layer.frame = bounds
            layer.addTopLeftEffect(cornerRadius: cornerRadius, themeColor: themeColor.cgColor)
            layer.name = Configuration.shadowLayerName

            return layer
        }()

        let insertSublayer = {
            if let self = self as? UIButton { // TODO: Consider another way
                self.layer.insertSublayer(newShadowLayer, below: self.imageView?.layer)
            } else {
                self.layer.insertSublayer(newShadowLayer, at: 0)
            }
        }

        if let layer = oldShadowLayer { // Layer already exists
            self.layer.replaceSublayer(layer, with: newShadowLayer)
        } else { // Layer does not exists
            insertSublayer()
        }
    }

}

extension CAShapeLayer {

    func addTopLeftEffect(
        cornerRadius: CGFloat,
        themeColor: CGColor = (R.color.soft() ?? .init()).cgColor
    ) {
        self.cornerRadius = cornerRadius
        shadowRadius = Configuration.shadowRadius
        shadowOpacity = Configuration.shadowOpacity

        shadowOffset = Configuration.topShadowOffset
        shadowColor = Configuration.topShadowColor
        backgroundColor = themeColor
    }

}

extension CALayer {

    func addBottomRightEffect(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        shadowRadius = Configuration.shadowRadius
        shadowOpacity = Configuration.shadowOpacity

        shadowOffset = Configuration.bottomShadowOffset
        shadowColor = Configuration.bottomShadowColor
        masksToBounds = false
    }

}

private enum Configuration {

    static let shadowLayerName = "com.wol.soft_shadow_layer"

    static let shadowRadius: CGFloat = 2
    static let shadowOpacity: Float = 1

    static let topShadowOffset = CGSize(width: -2.0, height: -2.0)
    static let bottomShadowOffset = CGSize(width: 2.0, height: 2.0)

    static let topShadowColor = R.color.white()?.cgColor
    static let bottomShadowColor = R.color.softShadow()?.cgColor

}
