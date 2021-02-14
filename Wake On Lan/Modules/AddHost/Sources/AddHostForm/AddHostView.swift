//
//  AddHostView.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit
import WOLUIComponents
import WOLResources
import SharedExtensions

protocol AddHostViewDelegate: AnyObject {
    func addHostViewDidPressSaveButton(_ view: AddHostView)
    func addHostViewDidPressBackButton(_ view: AddHostView)
}

class AddHostView: UIView {

    private let appearance = Appearance(); struct Appearance {
        let saveItemBarButtonVerticalInset: CGFloat = 0
        let saveItemBarButtonHorizontalInset: CGFloat = 6.0
        let backBarButtonVerticalInset: CGFloat = 6.0
        let backBarButtonHorizontalInset: CGFloat = 0
    }

    // MARK: - Properties

    weak var delegate: AddHostViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            TextInputCell.self,
            forCellReuseIdentifier: "\(TextInputCell.self)"
        )
        tableView.register(
            DeviceIconCell.self,
            forCellReuseIdentifier: "\(DeviceIconCell.self)"
        )
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = R.color.soft()

        return tableView
    }()

    lazy var saveItemButton: UIBarButtonItem = {
        let button = SoftUIView(circleShape: true)
        let image = R.image.save()?.with(tintColor: R.color.lightGray() ?? .init())
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)

        return UIBarButtonItem(with: button)
    }()

    lazy var backBarButton: UIBarButtonItem = {
        let button = SoftUIView(circleShape: true)
        let image = R.image.back()?.with(tintColor: R.color.lightGray() ?? .init())
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        return UIBarButtonItem(with: button)
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.white()
        setupTableView()
        registerNotifications()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension AddHostView {

    func registerNotifications() {
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

    func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    @objc func saveButtonPressed() {
        delegate?.addHostViewDidPressSaveButton(self)
    }

    @objc func backButtonPressed() {
        delegate?.addHostViewDidPressBackButton(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        // NOTE: We need to use keyboardFrame`End`UserInfoKey instead of
        // keyboardFrame`Begin`UserInfoKey because we using inputAccessoryView
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardSize = (notification.userInfo?[key] as? NSValue)?.cgRectValue else { return }
        let insets = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardSize.height, right: .zero)
        tableView.contentInset = insets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }

}

private extension UIBarButtonItem {

    convenience init(with view: SoftUIView) {
        self.init(customView: view)
        customView?.snp.makeConstraints {
            $0.size.equalTo(32)
        }
    }

}
