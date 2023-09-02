//  TextInputCell.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 01.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SnapKit
import UIKit
import WOLResources
import WOLUIComponents

final class TextInputCell: UITableViewCell {

    typealias OnExpandCompletion = () -> Void
    typealias OnExpandAction = (_ completion: OnExpandCompletion?) -> Void
    typealias OnNextResponderAction = (_ indexPath: IndexPath) -> Void

    // MARK: - Properties

    var onExpandAction: OnExpandAction?
    var onNextResponderAction: OnNextResponderAction?

    private lazy var textField: SoftUITextField = {
        let textField = SoftUITextField(frame: .zero)
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing

        return textField
    }()

    private let failureView = AddHostFailureView()

    private var textFormItem: TextFormItem?

    private var isExpanded = false {
        didSet {
            if isExpanded == oldValue { return }
            switch isExpanded {
            case true:
                failureView.show()
                failureView.isHidden = false
                onExpandAction?(nil)

            case false:
                failureView.hide()
                onExpandAction?({ [weak self] in
                    self?.failureView.isHidden = true
                })
            }
        }
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = Asset.Colors.primary.color
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func configureViews() {
        configureTextField()
        configureFailureLabel()
    }

    private func configureTextField() {
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func configureFailureLabel() {
        contentView.addSubview(failureView)
        failureView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.top.equalTo(textField.snp.bottom)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        // Hide error view by default
        failureView.isHidden = true
    }

    private func configureToolbarIfNeeded() {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDoneButton)
        )
        doneButton.tintColor = Asset.Colors.secondary.color
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }

    // MARK: - Action

    @objc private func textFieldValueChanged(_ textField: UITextField) {
        guard
            let item = textFormItem,
            let textValue = textField.text
        else {
            return
        }
        item.value = textValue
        isExpanded = !(item.isValid || textValue.isEmpty)
        guard item.needsUppercased else { return }
        textField.text = item.formatted?.uppercased()
    }

    @objc private func didTapDoneButton() {
        self.endEditing(true)
    }

}

// MARK: - UITextFieldDelegate

extension TextInputCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextResponderTag = textField.tag + 1
        guard
            let nextResponder = superview?.viewWithTag(nextResponderTag)
        else {
            textField.resignFirstResponder()
            return true
        }
        nextResponder.becomeFirstResponder()
        if let indexPath = textFormItem?.indexPath {
            onNextResponderAction?(indexPath)
        }
        return true
    }

    // NOTE: Grabbed from
    // https://www.hackingwithswift.com/example-code/uikit/
    // how-to-limit-the-number-of-characters-in-a-uitextfield-or-uitextview
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let maxLength = textFormItem?.maxLength else { return true }
        let currentText = textField.text ?? String.empty
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= maxLength
    }

}

// MARK: - FormConfigurable

extension TextInputCell: FormConfigurable {
    func configure(with formItem: FormItem) {
        guard case let .text(textFormItem) = formItem else { return }
        self.textFormItem = textFormItem
        textField.tag = textFormItem.indexPath?.section ?? .zero
        textField.text = textFormItem.value
        textField.placeholder = textFormItem.placeholder
        textField.keyboardType = textFormItem.keyboardType
        // Setup toolbar on number pad
        // TODO: Needs be refactored
        if textField.keyboardType == .numberPad {
            configureToolbarIfNeeded()
        }

        // Setup FailureView if needed
        guard let error = textFormItem.failureReason else { return }
        failureView.configure(with: error)
    }

}

private class AddHostFailureView: UIView {

    // MARK: Properties

    private let failureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.warning.color
        // TODO: Consider another font
        label.font = .boldSystemFont(ofSize: 12.0)

        return label
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with reason: AddHostForm.Error) {
        failureLabel.text = reason.description
    }

    func show() {
        addSubview(failureLabel)
        failureLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.greaterThanOrEqualToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10).priority(.low)
        }
    }

    func hide() {
        failureLabel.removeFromSuperview()
    }

}
