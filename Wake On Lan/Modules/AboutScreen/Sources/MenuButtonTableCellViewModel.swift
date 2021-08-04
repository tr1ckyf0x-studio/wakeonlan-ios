//
//  MenuButtonTableCellViewModel.swift
//  AboutScreen
//
//  Created by Dmitry on 04.08.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation

public struct MenuButtonCellViewModel {
    /// Represents displayed title
    let title: String
    /// Action that will be execute by tap on cell
    let action: (() -> Void)?
}
