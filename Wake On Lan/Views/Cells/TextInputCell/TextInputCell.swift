
//  TextInputCell.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 01.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

private class AddHostFailureView: UIView {
    
    // MARK: Properties
    private let failureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        // TODO: Consider another font
        label.font = .boldSystemFont(ofSize: 12.0)
        
        return label
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func configure(with reason: AddHostFailureReason) {
        failureLabel.text = String(describing: reason)
    }
    
    func show() {
        addSubview(failureLabel)
        failureLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.greaterThanOrEqualToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10).priority(.low)
        }
    }
    
    func hide() {
        failureLabel.removeFromSuperview()
    }
    
}

class TextInputCell: UITableViewCell {
    
    static let reuseIdentifier = "TextInputCell"
    
    // MARK: - Properties
    var onExpandAction: (( _ completionBlock: (() -> Void)? ) -> Void)?
    var onNextResponderAction: ((_ indexPath: IndexPath) -> Void)?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.addTarget(
            self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .allCharacters
        
        return textField
    }()
    
    private let failureView = AddHostFailureView()
    
    private var textFormItem: TextFormItem?
    
    private var expanded: Bool = false {
        didSet {
            if expanded == oldValue { return }
            switch expanded {
            case true:
                failureView.show()
                failureView.isHidden = false
                onExpandAction?(nil)
            case false:
                failureView.hide()
                onExpandAction?({ [unowned self] in
                    self.failureView.isHidden = true
                })
            }
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureFailureLabel() {
        contentView.addSubview(failureView)
        failureView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
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
            action: #selector(didTapDoneButton))
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: - Action
    @objc private func textFieldValueChanged(_ textField: UITextField) {
        guard let item = textFormItem,
            let textValue = textField.text else { return }
        item.value = textValue
        (item.isValid || textValue.isEmpty) ? (expanded = false) : (expanded = true)
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
        guard let nextResponder =
            superview?.viewWithTag(nextResponderTag) else {
            textField.resignFirstResponder()
            return true
        }
        nextResponder.becomeFirstResponder()
        if let indexPath = self.textFormItem?.indexPath {
            onNextResponderAction?(indexPath)
        }
        return true
    }

    // NOTE: Grabbed from
    // https://www.hackingwithswift.com/example-code/uikit/
    // how-to-limit-the-number-of-characters-in-a-uitextfield-or-uitextview
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string:
        String) -> Bool {
        guard let maxLength = textFormItem?.maxLength else { return true }
        let currentText = textField.text ?? ""
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
        failureView.configure(with: textFormItem.failureReason)
        textField.tag = textFormItem.indexPath?.section ?? 0
        textField.text = textFormItem.value
        textField.placeholder = textFormItem.placeholder
        textField.keyboardType = textFormItem.keyboardType
        // Setup toolbar on number pad
        // TODO: Need to refactoring
        guard textField.keyboardType == .numberPad else { return }
        configureToolbarIfNeeded()
    }

}
