//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import Foundation
import SharedModels
import SharedProtocols
import WOLResources
import WOLUIComponents

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
                return L10n.AddHostFailure.invalidMACAddress

            case .invalidIPAddress:
                return L10n.AddHostFailure.invalidIPAddress

            case .invalidPort:
                return L10n.AddHostFailure.invalidPort

            case .invalidTitle:
                return L10n.AddHostFailure.invalidTitle

            case .unknown:
                return L10n.AddHostFailure.unknown
            }
        }
    }

    // MARK: - Constants

    private enum Placeholder {
        static let title = L10n.AddHost.AddHost.Placeholder.title
        static let macAddress = L10n.AddHost.AddHost.Placeholder.macAddress
        static let ipAddress = L10n.AddHost.AddHost.Placeholder.ipAddress
        static let port = L10n.AddHost.AddHost.Placeholder.port
    }

    // MARK: - Properties

    private(set) var sections = [FormSection]()

    private(set) var host: Host? {
        didSet {
            guard let host = host else { return }
            let sfSymbol = SFSymbolFactory.build(from: host.iconName)
            iconModel = sfSymbol.map { IconModel(sfSymbol: $0) }
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
        item.keyboardType = .default

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
            header: .init(header: L10n.AddHost.title),
            footer: .init(footer: L10n.AddHost.titleDescription),
            kind: .title
        )

        let macAddressSection = FormSection.section(
            content: [macAddressFormItem],
            header: .init(header: L10n.AddHost.macAddress),
            footer: .init(footer: L10n.AddHost.macAddressDescription),
            kind: .macAddress
        )

        let ipAddressSection = FormSection.section(
            content: [ipAddressFormItem],
            header: .init(header: L10n.AddHost.ipAddress, mandatory: false),
            footer: .init(footer: L10n.AddHost.ipAddressDescription),
            kind: .ipAddress
        )

        let portSection = FormSection.section(
            content: [portFormItem],
            header: .init(header: L10n.AddHost.port, mandatory: false),
            footer: .init(footer: L10n.AddHost.portDescription),
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
        sections.allSatisfy {
            $0.items.allSatisfy { $0.isValid }
        }
    }

}
