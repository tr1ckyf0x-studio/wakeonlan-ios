//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class AddHostForm: Form {

    // MARK: - Error
    enum Error: LocalizedError {
        case invalidMACAddress
        case invalidIPAddress
        case invalidPort
        case invalidTitle
        case unknown

        var description: String {
            switch self {
            case .invalidMACAddress:
                return R.string.addHostFailure.invalidMACAddress()
            case .invalidIPAddress:
                return R.string.addHostFailure.invalidIPAddress()
            case .invalidPort:
                return R.string.addHostFailure.invalidPort()
            case .invalidTitle:
                return R.string.addHostFailure.invalidTitle()
            case .unknown:
                return R.string.addHostFailure.unknown()
            }
        }
    }

    // MARK: - Constants
    private enum Placeholder {
        static let title = "e.g. MacBook or NAS"
        static let macAddress = "XX:XX:XX:XX:XX:XX"
        static let ipAddress = "255.255.255.255"
        static let port = "9"
    }

    // MARK: - Properties
    private(set) var formSections = [FormSection]()

    private(set) var host: Host? {
        didSet {
            guard let host = host else { return }
            iconModel = IconModel(pictureName: host.iconName)
            titleItem.value = host.title
            macAddressItem.value = host.macAddress
            ipAddressItem.value = host.ipAddress
            portItem.value = host.port
        }
    }

    var iconModel: IconModel? = .init()
    var title: String?
    var macAddress: String?
    var ipAddress: String?
    var port: String?

    // MARK: - Section items
    private lazy var iconSectionItems: [FormItem] = {
        guard let model = iconModel else { return [] }

        return [FormItem.icon(model)]
    }()
    
    private lazy var titleItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = Placeholder.title
        item.onValueChanged = { [weak self] value in
            self?.title = value
        }
        item.validator = TextValidator(strategy: AddHostValidationStrategy.title)
        item.needsUppercased = false

        return item
    }()
    
    private lazy var macAddressItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = Placeholder.macAddress
        item.onValueChanged = { [weak self] value in
            self?.macAddress = value
        }
        item.validator = TextValidator(strategy: AddHostValidationStrategy.macAddress)
        item.formatter = TextFormatter(strategy: AddHostFormatterStrategy.macAddress)
        item.failureReason = .invalidMACAddress
        item.keyboardType = .asciiCapable
        item.maxLength = 17
        item.needsUppercased = true
        
        return item
    }()
    
    private lazy var ipAddressItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = Placeholder.ipAddress
        item.defaultValue = "255.255.255.255"
        item.onValueChanged = { [weak self] value in
            self?.ipAddress = value
        }
        item.validator = TextValidator(strategy: AddHostValidationStrategy.ipAddress)
        item.failureReason = .invalidIPAddress
        item.keyboardType = .numbersAndPunctuation
        item.isMandatory = false

        return item
    }()
    
    private lazy var portItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = Placeholder.port
        item.defaultValue = "9"
        item.onValueChanged = { [weak self] value in
            self?.port = value
        }
        item.validator = TextValidator(strategy: AddHostValidationStrategy.port)
        item.failureReason = .invalidPort
        item.keyboardType = .numberPad
        item.isMandatory = false
        item.maxLength = 5

        return item
    }()

    // MARK: - Init
    init(host: Host? = nil) {
        makeSections()
        defer { self.host = host }
    }

    // MARK: - Private
    private func makeSections() {
        let titleFormItem = FormItem.text(titleItem)
        let macAddressFormItem = FormItem.text(macAddressItem)
        let ipAddressFormItem = FormItem.text(ipAddressItem)
        let portFormItem = FormItem.text(portItem)

        let deviceIconSection = FormSection.section(content: iconSectionItems,
                                                    kind: .deviceIcon)

        let titleSection = FormSection.section(
            content: [titleFormItem],
            header: .init(header: R.string.addHost.title()),
            footer: .init(footer: R.string.addHost.titleDescription()),
            kind: .title)

        let macAddressSection = FormSection.section(
            content: [macAddressFormItem],
            header: .init(header: R.string.addHost.macAddress()),
            footer: .init(footer: R.string.addHost.macAddressDescription()),
            kind: .macAddress)

        let ipAddressSection = FormSection.section(
            content: [ipAddressFormItem],
            header: .init(header: R.string.addHost.ipAddress(), mandatory: false),
            footer: .init(footer: R.string.addHost.ipAddressDescription()),
            kind: .ipAddress)
        
        let portSection = FormSection.section(
            content: [portFormItem],
            header: .init(header: R.string.addHost.port(), mandatory: false),
            footer: .init(footer: R.string.addHost.portDescription()),
            kind: .port)
        
        formSections =
            [deviceIconSection, titleSection, macAddressSection, ipAddressSection, portSection]
    }

}

extension AddHostForm {
    var isValid: Bool {
        let formIsValid = formSections.reduce(true) { formResult, formSection -> Bool in
            let sectionIsValid = formSection.items.reduce(true) { sectionResult, formItem -> Bool in
                return sectionResult && formItem.isValid
            }
            return formResult && sectionIsValid
        }
        return formIsValid
    }

}
