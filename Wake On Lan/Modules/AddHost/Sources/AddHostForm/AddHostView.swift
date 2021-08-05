//
//  AddHostView.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SnapKit
import SharedExtensions
import UIKit
import WOLUIComponents
import WOLResources

protocol AddHostViewDelegate: AnyObject {
    func addHostViewDidPressSaveButton(_ view: AddHostView)
    func addHostViewDidPressBackButton(_ view: AddHostView)
}

final class AddHostView: UIView {

    // MARK: - Appearance

    private let appearance = Appearance(); struct Appearance {
        let barButtonImageViewInset: CGFloat = 6.0
    }

    // MARK: - Properties

    weak var delegate: AddHostViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TextInputCell.self, forCellReuseIdentifier: "\(TextInputCell.self)")
        tableView.register(DeviceIconCell.self, forCellReuseIdentifier: "\(DeviceIconCell.self)")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Colors.soft.color

        return tableView
    }()

    lazy var saveItemButton: UIBarButtonItem = {
        let button = SoftUIView(circleShape: true)
        let image = UIImage(sfSymbol: ButtonIcon.checkmark, withConfiguration: .init(weight: .semibold))
        let imageView = UIImageView(image: image)
        imageView.tintColor = Asset.Colors.lightGray.color
        imageView.contentMode = .scaleAspectFit
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(appearance.barButtonImageViewInset)
        }
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)

        return UIBarButtonItem(with: button)
    }()

    lazy var backBarButton: UIBarButtonItem = {
        let button = SoftUIView(circleShape: true)
        let image = UIImage(sfSymbol: ButtonIcon.chevronBackward, withConfiguration: .init(weight: .semibold))
        let imageView = UIImageView(image: image)
        imageView.tintColor = Asset.Colors.lightGray.color
        imageView.contentMode = .scaleAspectFit
        button.configure(with: SoftUIViewModel(contentView: imageView))
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(appearance.barButtonImageViewInset)
        }
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        return UIBarButtonItem(with: button)
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Asset.Colors.white.color
        setupTableView()
        registerNotifications()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension AddHostView {

    typealias ObserverArgs = (selector: Selector, notification: NSNotification.Name)

    func registerNotifications() {
        [
            ObserverArgs(#selector(keyboardWillShow(notification:)), UIResponder.keyboardWillShowNotification),
            ObserverArgs(#selector(keyboardWillHide(notification:)), UIResponder.keyboardWillHideNotification)
        ].forEach {
            NotificationCenter.default.addObserver(self, selector: $0.selector, name: $0.notification, object: nil)
        }
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
