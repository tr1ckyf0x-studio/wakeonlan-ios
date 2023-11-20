//
//  AboutScreenMenuButtonViewViewModel.swift
//  AboutScreen
//
//  Created by Dmitry on 04.08.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import SharedProtocolsAndModels

struct AboutScreenMenuButtonViewViewModel {
    /// Represents displayed title
    let title: String
    /// Represents icon
    let symbol: SFSymbolRepresentable
    /// Action that will be executed by tap
    let action: (() -> Void)?
}
