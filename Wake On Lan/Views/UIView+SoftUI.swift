//
//  UIView+SoftUI.swift
//  Wake on LAN
//
//  Created by Dmitry on 07.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

public extension UIColor {
    static let softUIColor: UIColor = .init(red: 241 / 255, green: 243 / 255, blue: 246 / 255, alpha: 1.0)
}

class SoftUIView: UIView, SoftUIProtocol {

    private let shadowLayerName = "com.wol.soft_shadow_layer"

    // MARK: - Properties
    var themeColor: UIColor

    var cornerRadius: CGFloat

    // MARK: - Init
    init(cornerRadius: CGFloat = 15.0, themeColor: UIColor = .softUIColor) {
        self.themeColor = themeColor
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SoftUIProtocol
    func addSoftUIEffectIfNeeded() {
        self.layer.addBottomRightEffect(cornerRadius: cornerRadius)
        let oldShadowLayer = self.layer.sublayers?.first {
            $0.name == self.shadowLayerName
        }

        let newShadowLayer = makeShadowLayer()
        newShadowLayer.name = shadowLayerName

        if let layer = oldShadowLayer { // Layer already exists
            self.layer.replaceSublayer(layer, with: newShadowLayer)
        } else { // Layer does not exists
            self.layer.insertSublayer(newShadowLayer, at: 0)
        }
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        addSoftUIEffectIfNeeded()
    }

}

extension CALayer {

    func addBottomRightEffect(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = 2
        self.shadowOpacity = 1

        self.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.shadowColor = UIColor(red: 223 / 255, green: 228 / 255, blue: 238 / 255, alpha: 1.0).cgColor
        self.masksToBounds = false
    }

}

extension CAShapeLayer {

    func addTopLeftEffect(cornerRadius: CGFloat, themeColor: CGColor = UIColor.softUIColor.cgColor) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = 2
        self.shadowOpacity = 1

        self.shadowOffset = CGSize(width: -2.0, height: -2.0)
        self.shadowColor = UIColor.white.cgColor
        self.backgroundColor = themeColor
    }

}
