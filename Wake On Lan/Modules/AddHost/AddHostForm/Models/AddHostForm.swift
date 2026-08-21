//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 17.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CoreDataService
import Foundation
import WOLSharedProtocolsAndModels

@MainActor
final class AddHostForm: AddHostFormRepresentable {
    // MARK: - Error

    enum Error: LocalizedError {
        case invalidMACAddress
        case invalidPort
        case unknown

        var description: String {
            switch self {
            case .invalidMACAddress:
                return String(localized: .addHostFormFieldMacAddressFailureInvalidMACAddress)

            case .invalidPort:
                return String(localized: .addHostFormFieldPortFailureInvalidPort)

            case .unknown:
                return String(localized: .addHostFormFailureUnknown)
            }
        }
    }

    // MARK: - Properties

    var iconModel = IconModel(symbol: HostIcon.desktopcomputer.symbol)

    private(set) var sections = [FormSection]()

    private(set) var host: Host?

    private(set) var title: String = .empty
    private(set) var macAddress: String = .empty
    private(set) var destination: String?
    private(set) var port: String?

    // MARK: - Section items

    private lazy var iconSectionItems = [FormItem.icon(iconModel)]

    private lazy var titleItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = String(localized: .addHostFormFieldNamePlaceholder)
        item.onValueChanged = { [weak self] value in
            self?.title = value ?? .empty
        }
        item.validator = TextValidator(strategy: AddHostValidationStrategy.title)
        item.needsUppercased = false
        item.keyboardType = .default

        return item
    }()

    private lazy var macAddressItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = String(localized: .addHostFormFieldMacAddressPlaceholder)
        item.onValueChanged = { [weak self] value in
            self?.macAddress = value ?? .empty
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
        item.placeholder = String(localized: .addHostFormFieldHostPlaceholder)
        item.defaultValue = String(localized: .addHostFormFieldHostPlaceholder)
        item.onValueChanged = { [weak self] value in
            self?.destination = value
        }
        item.keyboardType = .numbersAndPunctuation
        item.isMandatory = false

        return item
    }()

    private lazy var portItem: TextFormItem = {
        let item = TextFormItem()
        item.placeholder = String(localized: .addHostFormFieldPortPlaceholder)
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

    init(host: Host? = nil) {
        self.host = host
        makeSections()
        applyValues(from: host)
    }

    // MARK: - Private

    /// Fills the form fields from an existing host.
    ///
    /// - Note: Called explicitly rather than from a `didSet` on `host`. This used to be
    ///   `defer { self.host = host }` in `init`, which relied on a property observer firing for an
    ///   assignment made inside an initializer — that worked in Swift 5 but **silently stopped
    ///   working in Swift 6**, leaving every edit form empty. Do not reintroduce the trick.
    private func applyValues(from host: Host?) {
        guard let host else { return }
        // NOTE: An unresolvable icon must not stop the rest of the form from being filled in.
        // Hosts created before the migration to SF Symbols still store legacy asset names
        // ("desktop", "other", "router"), which no Core Data mapping rewrites. Bailing out here
        // opened such a host as a completely empty form, and saving it then overwrote the stored
        // destination and port with nil. Fall back to the default icon instead.
        if let hostIcon = HostIcon(systemName: host.iconName) {
            iconModel = IconModel(symbol: hostIcon.symbol)
        }
        titleItem.value = host.title
        macAddressItem.value = host.macAddress
        destinationItem.value = host.destination
        portItem.value = host.port
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
            header: FormSection.Header(header: String(localized: .addHostFormFieldNameTitle)),
            footer: FormSection.Footer(footer: String(localized: .addHostFormFieldNameDescription)),
            kind: .title
        )

        let macAddressSection = FormSection.section(
            content: [macAddressFormItem],
            header: FormSection.Header(header: String(localized: .addHostFormFieldMacAddressTitle)),
            footer: FormSection.Footer(footer: String(localized: .addHostFormFieldMacAddressDescription)),
            kind: .macAddress
        )

        let destinationSection = FormSection.section(
            content: [destinationFormItem],
            header: FormSection.Header(header: String(localized: .addHostFormFieldHostTitle), mandatory: false),
            footer: FormSection.Footer(footer: String(localized: .addHostFormFieldHostDescription)),
            kind: .destination
        )

        let portSection = FormSection.section(
            content: [portFormItem],
            header: FormSection.Header(header: String(localized: .addHostFormFieldPortTitle), mandatory: false),
            footer: FormSection.Footer(footer: String(localized: .addHostFormFieldPortDescription)),
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
