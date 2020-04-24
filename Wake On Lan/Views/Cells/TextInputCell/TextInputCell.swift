//
//  TextInputCell.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 01.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SnapKit

class TextInputCell: UITableViewCell {
    
    static let reuseIdentifier = "TextInputCell"
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private var textFormItem: TextFormItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        configureTextField()
    }
    
    private func configureTextField() {
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        textFormItem?.value = textField.text
    }

}

extension TextInputCell: FormConfigurable {
    func configure(with formItem: FormItem) {
        guard case let .text(textFormItem) = formItem else { return }
        self.textFormItem = textFormItem
        textField.text = textFormItem.value
        textField.placeholder = textFormItem.placeholder
    }
}
