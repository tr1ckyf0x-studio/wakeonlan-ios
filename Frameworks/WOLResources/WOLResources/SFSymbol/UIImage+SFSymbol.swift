//
//  UIImage+SFSymbol.swift
//  
//
//  Created by Vladislav Lisianskii on 31.07.2021.
//

import SharedProtocolsAndModels
import UIKit

extension UIImage {
    public convenience init?(
        sfSymbol: SFSymbolRepresentable,
        withConfiguration configuration: SymbolConfiguration? = nil
    ) {
        self.init(systemName: sfSymbol.systemName, withConfiguration: configuration)
    }
}
