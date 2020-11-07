//
//  HostListView.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

protocol HostListViewDelegate: class {
    func hostListViewDidPressAddButton(_ view: HostListView)
}

class HostListView: UIView {

    private enum Constants {
        static let addItemButtonDimensions = 32.0
    }

    weak var delegate: HostListViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HostListTableViewCell.self, forCellReuseIdentifier: "\(HostListTableViewCell.self)")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension

        return tableView
    }()

    lazy var addItemButton: UIBarButtonItem = {
        let addButton: SoftUIButton = {
            let addButton = SoftUIButton(cornerRadius: 16.0)
            addButton.setImage(R.image.add(), for: .normal)
            addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
            let spacing: CGFloat = 5
            addButton.imageEdgeInsets =
                UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

            return addButton
        }()

        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: addButton)
            button.customView?.snp.makeConstraints {
                $0.size.equalTo(Constants.addItemButtonDimensions)
            }

            return button
        }()

        return barButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.soft()
        createSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
    }

    private func createSubviews() {
        setupTableView()
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    @objc private func addButtonPressed(_ sender: UIButton) {
        delegate?.hostListViewDidPressAddButton(self)
    }
}
