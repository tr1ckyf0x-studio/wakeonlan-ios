//
//  EmptyCell.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 12.06.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
