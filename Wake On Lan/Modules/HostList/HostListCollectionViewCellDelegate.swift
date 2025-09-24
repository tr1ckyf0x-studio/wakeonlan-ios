//
//  HostListCollectionViewCellDelegate.swift
//  HostList
//
//  Created by Vladislav Lisianskii on 01.01.2024.
//

protocol HostListCollectionViewCellDelegate: AnyObject {

    func hostListCellDidTapDelete(_ cell: HostListCollectionViewCell)

    func hostListCellDidTapInfo(_ cell: HostListCollectionViewCell)

    func hostListCellDidTap(_ cell: HostListCollectionViewCell)

}
