//
//  FontRegister.swift
//  WOLResources
//
//  Created by Dmitry on 18.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreText
import Foundation

public protocol RegistersFont {
    func registerAvailableFonts()
}

public final class FontRegister {

    // MARK: - Properties

    private lazy var bundle = Bundle.module

    private let provider: ProvidesBundleInfo

    // MARK: - Init

    public init(provider: ProvidesBundleInfo = BundleInfoProvider()) {
        self.provider = provider
    }

}

// MARK: - RegistersFont

extension FontRegister: RegistersFont {

    public func registerAvailableFonts() {
        provider.fetchBundleInfo { bundleInfo in
            guard let appFonts = bundleInfo.appFonts else { return }
            appFonts.forEach {
                guard let font = bundle.url(forResource: $0, withExtension: nil) else { return }
                CTFontManagerRegisterFontsForURL(font as CFURL, .process, nil)
            }
        }
    }

}
