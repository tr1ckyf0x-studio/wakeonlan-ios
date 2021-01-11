//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import WOLUIComponents
import WOLResources
import SharedModels
import SharedProtocols
import CoreDataService

final class AddHostForm: AddHostFormRepresentable {

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

    private(set) var sections = [FormSection]()

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
    private(set) var title: String?
    private(set) var macAddress: String?
    private(set) var ipAddress: String?
    private(set) var port: String?

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
        item.defaultValue = Placeholder.ipAddress
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
        item.defaultValue = Placeholder.port
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

    public init(host: Host? = nil) {
        makeSections()
        // swiftlint:disable inert_defer
        defer { self.host = host } // Otherwise didSet does not call
    }

    // MARK: - Private

    private func makeSections() {
        let titleFormItem = FormItem.text(titleItem)
        let macAddressFormItem = FormItem.text(macAddressItem)
        let ipAddressFormItem = FormItem.text(ipAddressItem)
        let portFormItem = FormItem.text(portItem)

        let deviceIconSection = FormSection.section(
            content: iconSectionItems,
            kind: .deviceIcon
        )

        let titleSection = FormSection.section(
            content: [titleFormItem],
            header: .init(header: R.string.addHost.title()),
            footer: .init(footer: R.string.addHost.titleDescription()),
            kind: .title
        )

        let macAddressSection = FormSection.section(
            content: [macAddressFormItem],
            header: .init(header: R.string.addHost.macAddress()),
            footer: .init(footer: R.string.addHost.macAddressDescription()),
            kind: .macAddress
        )

        let ipAddressSection = FormSection.section(
            content: [ipAddressFormItem],
            header: .init(header: R.string.addHost.ipAddress(), mandatory: false),
            footer: .init(footer: R.string.addHost.ipAddressDescription()),
            kind: .ipAddress
        )

        let portSection = FormSection.section(
            content: [portFormItem],
            header: .init(header: R.string.addHost.port(), mandatory: false),
            footer: .init(footer: R.string.addHost.portDescription()),
            kind: .port
        )

        sections = [
            deviceIconSection,
            titleSection,
            macAddressSection,
            ipAddressSection,
            portSection
        ]
    }

}

// MARK: - FormValidable

extension AddHostForm {

    public var isValid: Bool {
        sections.allSatisfy { formSection -> Bool in
            formSection.items.allSatisfy { formItem -> Bool in
                formItem.isValid
            }
        }
    }

}