//
//  HostListCellViewModel.swift
//  
//
//  Created by Vladislav Lisianskii on 05.10.2022.
//

import Foundation

struct HostListCellViewModel: Hashable, Equatable {
    let title: String
    let iconName: String
    let macAddress: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(iconName)
        hasher.combine(macAddress)
    }
}
