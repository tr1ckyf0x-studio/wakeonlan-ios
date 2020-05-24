//
//  AddHostView.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

protocol AddHostViewDelegate: class {
    func addHostViewDidPressSaveButton(_ view: AddHostView)
}

class AddHostView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TextInputCell.self, forCellReuseIdentifier: TextInputCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    lazy var saveItemButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        return barButtonItem
    }()
    
    weak var delegate: AddHostViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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
    
    @objc private func saveButtonPressed() {
        delegate?.addHostViewDidPressSaveButton(self)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
