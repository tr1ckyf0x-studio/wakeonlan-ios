//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import Foundation
import SharedProtocolsAndModels
import WOLResources
import WOLUIComponents

final class AddHostForm: AddHostFormRepresentable {

    // MARK: - Error

    enum Error: LocalizedError {
        case invalidMACAddress
        case invalidPort
        case unknown

        var description: String {
            switch self {
            case .invalidMACAddress:
                L10n.AddHost.Form.Field.MacAddress.Failure.invalidMACAddress

            case .invalidPort:
                L10n.AddHost.Form.Field.Port.Failure.invalidPort

            case .unknown:
                L10n.AddHost.Form.Failure.unknown
            }
        }
    }

    // MARK: - Properties

    private(set) var sections = [FormSection]()

    private(set) var host: Host? {
        didSet {
            guard let host else { return }
            let sfSymbol = SFSymbolFactory.build(from: host.iconName)
            iconModel = sfSymbol.map { IconModel(sfSymbol: $0) }
            titleItem.value = host.title
            macAddressItem.value = host.macAddress
            destinationItem.value = host.destination
            portItem.value = host.port
        }
    }

    var iconModel: IconModel? = IconModel(sfSymbol: HostIcon.desktopcomputer)
    private(set) var title: String?
    private(set) var macAddress: String?
    private(set) var destination: String?
    private(set) var port: String?

    // MARK: - Section items

    private lazy var iconSectionItems: [FormItem] = {
        guard let iconModel else { return [] }
        return [FormItem.icon(iconModel)]
    }()

    private lazy var titleItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = L10n.AddHost.Form.Field.Name.placeholder
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
        item.placeholder = L10n.AddHost.Form.Field.MacAddress.placeholder
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

    private lazy var destinationItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = L10n.AddHost.Form.Field.Host.placeholder
        item.defaultValue = item.placeholder
        item.onValueChanged = { [weak self] value in
            self?.destination = value
        }
        item.keyboardType = .numbersAndPunctuation
        item.isMandatory = false

        return item
    }()

    private lazy var portItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = L10n.AddHost.Form.Field.Port.placeholder
        item.defaultValue = item.placeholder
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
        // swiftlint:disable:next inert_defer
        defer { self.host = host } // Otherwise didSet does not call
    }

    // MARK: - Private

    private func makeSections() {
        let titleFormItem = FormItem.text(titleItem)
        let macAddressFormItem = FormItem.text(macAddressItem)
        let destinationFormItem = FormItem.text(destinationItem)
        let portFormItem = FormItem.text(portItem)

        let deviceIconSection = FormSection.section(content: iconSectionItems, kind: .deviceIcon)

        let titleSection = FormSection.section(
            content: [titleFormItem],
            header: FormSection.Header(header: L10n.AddHost.Form.Field.Name.title),
            footer: FormSection.Footer(footer: L10n.AddHost.Form.Field.Name.description),
            kind: .title
        )

        let macAddressSection = FormSection.section(
            content: [macAddressFormItem],
            header: FormSection.Header(header: L10n.AddHost.Form.Field.MacAddress.title),
            footer: FormSection.Footer(footer: L10n.AddHost.Form.Field.MacAddress.description),
            kind: .macAddress
        )

        let destinationSection = FormSection.section(
            content: [destinationFormItem],
            header: FormSection.Header(header: L10n.AddHost.Form.Field.Host.title, mandatory: false),
            footer: FormSection.Footer(footer: L10n.AddHost.Form.Field.Host.description),
            kind: .destination
        )

        let portSection = FormSection.section(
            content: [portFormItem],
            header: FormSection.Header(header: L10n.AddHost.Form.Field.Port.title, mandatory: false),
            footer: FormSection.Footer(footer: L10n.AddHost.Form.Field.Port.description),
            kind: .port
        )

        sections = [
            deviceIconSection,
            titleSection,
            macAddressSection,
            destinationSection,
            portSection
        ]
    }

}

// MARK: - FormValidable

extension AddHostForm {
    public var isValid: Bool {
        sections
            .lazy
            .flatMap(\.items)
            .allSatisfy(\.isValid)
    }
}
