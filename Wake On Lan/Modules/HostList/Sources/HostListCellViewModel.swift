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
}
