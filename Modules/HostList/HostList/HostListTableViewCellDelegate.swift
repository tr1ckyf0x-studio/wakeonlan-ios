//
//  HostListTableViewCellDelegate.swift
//  Wake on LAN
//
//  Created by Dmitry on 19.10.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

protocol HostListTableViewCellDelegate: AnyObject {

    func hostListCellDidTapDelete(_ cell: HostListTableViewCell)

    func hostListCellDidTapInfo(_ cell: HostListTableViewCell)

    func hostListCellDidTap(_ cell: HostListTableViewCell)

}
