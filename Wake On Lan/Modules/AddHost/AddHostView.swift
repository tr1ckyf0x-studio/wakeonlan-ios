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
    func addHostViewDidPressBackButton(_ view: AddHostView)
}

class AddHostView: UIView {

    // MARK: - Properties
    weak var delegate: AddHostViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            TextInputCell.self, forCellReuseIdentifier: TextInputCell.reuseIdentifier)
        tableView.register(
            DeviceIconCell.self, forCellReuseIdentifier: "\(DeviceIconCell.self)")
        tableView.register(
            EmptyCell.self, forCellReuseIdentifier: "\(EmptyCell.self)")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = .softUIColor

        return tableView
    }()
    
    lazy var saveItemButton: UIBarButtonItem = {
        let saveButton: SoftUIButton = {
            let addButton = SoftUIButton(roundShape: true)
            addButton.setImage(R.image.save()?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.addTarget(self,
                                action: #selector(saveButtonPressed),
                                for: .touchUpInside)
            let spacing: CGFloat = 6
            addButton.imageEdgeInsets = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
            addButton.imageView?.contentMode = .scaleAspectFit
            addButton.imageView?.tintColor = .init(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
            
            return addButton
        }()
        
        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: saveButton)
            button.customView?.snp.makeConstraints {
                $0.width.height.equalTo(32)
            }
            
            return button
        }()
        
        return barButton
    }()
    
    lazy var backBarButton: UIBarButtonItem = {
        let addButton: SoftUIButton = {
            let addButton = SoftUIButton(roundShape: true)
            addButton.setImage(R.image.back(), for: .normal)
            addButton.addTarget(self,
                                action: #selector(backButtonPressed),
                                for: .touchUpInside)
            let spacing: CGFloat = 5
            addButton.imageEdgeInsets = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
            
            return addButton
        }()
        
        let barButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: addButton)
            button.customView?.snp.makeConstraints {
                $0.width.height.equalTo(32)
            }
            
            return button
        }()
        
        return barButton
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        registerNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @objc private func saveButtonPressed() {
        delegate?.addHostViewDidPressSaveButton(self)
    }
    
    @objc private func backButtonPressed() {
        delegate?.addHostViewDidPressBackButton(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // NOTE: We need to use keyboardFrame`End`UserInfoKey instead of
        // keyboardFrame`Begin`UserInfoKey because we using inputAccessoryView
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardSize = (notification.userInfo?[key] as? NSValue)?.cgRectValue else { return }
        let insets = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardSize.height, right: .zero)
        tableView.contentInset = insets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
}
