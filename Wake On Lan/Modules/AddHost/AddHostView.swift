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

    // MARK: - Properties
    weak var delegate: AddHostViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            TextInputCell.self, forCellReuseIdentifier: TextInputCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag

        return tableView
    }()
    
    lazy var saveItemButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        return barButtonItem
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        createSubviews()
        registerNotifications()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
    }
    
    // MARK: - Private
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
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
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // NOTE: We need to use keyboardFrame`End`UserInfoKey instead of
        // keyboardFrame`Begin`UserInfoKey because we using inputAccessoryView
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardSize = (notification.userInfo?[key] as? NSValue)?.cgRectValue else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = insets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
}
