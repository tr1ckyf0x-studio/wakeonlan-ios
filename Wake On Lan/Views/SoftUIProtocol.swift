//
//  SoftUIProtocol.swift
//  Wake on LAN
//
//  Created by Dmitry on 10.07.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

protocol SoftUIProtocol where Self : UIView {

    var themeColor: UIColor { get }
    
    var cornerRadius: CGFloat { get }

    func addSoftUIEffectIfNeeded()
    
    func makeShadowLayer() -> CAShapeLayer

}

extension SoftUIProtocol {

    func makeShadowLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.addTopLeftEffect(cornerRadius: cornerRadius, themeColor: themeColor.cgColor)
        
        return layer
    }

}
