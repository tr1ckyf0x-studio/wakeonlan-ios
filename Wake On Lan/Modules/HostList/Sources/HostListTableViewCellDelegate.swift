//
//  HostListTableViewCellDelegate.swift
//  Wake on LAN
//
//  Created by Dmitry on 19.10.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService

protocol HostListTableViewCellDelegate: AnyObject {

    func hostListCellDidTapDelete(_ cell: HostListTableViewCell, model: Host)

    func hostListCellDidTapInfo(_ cell: HostListTableViewCell, model: Host)

    func hostListCellDidTap(_ cell: HostListTableViewCell, model: Host)

}
