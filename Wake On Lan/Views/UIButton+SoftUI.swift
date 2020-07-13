//
//  UIButton+SoftUI.swift
//  Wake on LAN
//
//  Created by Dmitry on 09.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class SoftUIButton: UIButton, SoftUIProtocol {
    
    private let shadowLayerName = "com.wol.soft_shadow_layer"

    // MARK: - Override
    open override var isHighlighted: Bool {
        didSet {
            pressed = isHighlighted ? true : false
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            pressed = isSelected ? false : true
        }
    }
        
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if roundShape { cornerRadius = bounds.height / 2 }
        addSoftUIEffectIfNeeded()
    }

    // MARK: - Properties
    var themeColor: UIColor
    
    var cornerRadius: CGFloat
    
    private var pressed: Bool = false {
        didSet {
            switch pressed {
            case true:
                self.layer.shadowOffset = CGSize(width: -2, height: -2)
                self.layer.sublayers?[0].shadowOffset = CGSize(width: 2, height: 2)
                self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
            case false:
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.sublayers?[0].shadowOffset = CGSize(width: -2, height: -2)
                self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 2)
            }
        }
    }
    
    private var roundShape: Bool = false
    
    // MARK: - Init
    init(roundShape: Bool = false, cornerRadius: CGFloat = 15.0, themeColor: UIColor = .softUIColor) {
        self.roundShape = roundShape
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

        if oldShadowLayer == nil { // Layer does not exists
            self.layer.insertSublayer(newShadowLayer, below: self.imageView?.layer)
        } else { // Layer already exists
            self.layer.replaceSublayer(oldShadowLayer ?? CAShapeLayer(), with: newShadowLayer)
        }
    }
    
}
