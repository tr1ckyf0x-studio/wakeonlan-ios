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

    // MARK: - Properties
    var title: String?
    var macAddress: String?
    var ipAddress: String?
    var port: String?
    
    private(set) var formSections = [FormSection]()

    // MARK: - Init
    init() {
        configureItems()
    }

    // MARK: - Private
    private func configureItems() {

        let deviceIconFormItem = FormItem.icon
        
        let titleTextFormItem = TextFormItem()
        titleTextFormItem.placeholder = "e.g. MacBook or NAS"
        titleTextFormItem.onValueChanged = { [weak self] value in
            self?.title = value
        }
        titleTextFormItem.validator =
            TextValidator(strategy: AddHostValidationStrategy.title)
        titleTextFormItem.needsUppercased = false
        let titleFormItem = FormItem.text(titleTextFormItem)
        
        let macAddressTextFormItem = TextFormItem()
        macAddressTextFormItem.placeholder = "XX:XX:XX:XX:XX:XX"
        macAddressTextFormItem.onValueChanged = { [weak self] value in
            self?.macAddress = value
        }
        macAddressTextFormItem.validator =
            TextValidator(strategy: AddHostValidationStrategy.macAddress)
        macAddressTextFormItem.formatter =
            TextFormatter(strategy: AddHostFormatterStrategy.macAddress)
        macAddressTextFormItem.failureReason = .invalidMACAddress
        macAddressTextFormItem.keyboardType = .asciiCapable
        macAddressTextFormItem.maxLength = 17
        macAddressTextFormItem.needsUppercased = true
        let macAddressFormItem = FormItem.text(macAddressTextFormItem)
        
        let ipAddressTextFormItem = TextFormItem()
        ipAddressTextFormItem.placeholder = "255.255.255.255"
        ipAddressTextFormItem.defaultValue = "255.255.255.255"
        ipAddressTextFormItem.onValueChanged = { [weak self] value in
            self?.ipAddress = value
        }
        ipAddressTextFormItem.validator =
            TextValidator(strategy: AddHostValidationStrategy.ipAddress)
        ipAddressTextFormItem.failureReason = .invalidIPAddress
        ipAddressTextFormItem.keyboardType = .numbersAndPunctuation
        ipAddressTextFormItem.isMandatory = false
        let ipAddressFormItem = FormItem.text(ipAddressTextFormItem)
        
        let portTextFormItem = TextFormItem()
        portTextFormItem.placeholder = "9"
        portTextFormItem.defaultValue = "9"
        portTextFormItem.onValueChanged = { [weak self] value in
            self?.port = value
        }
        portTextFormItem.validator =
            TextValidator(strategy: AddHostValidationStrategy.port)
        portTextFormItem.failureReason = .invalidPort
        portTextFormItem.keyboardType = .numberPad
        portTextFormItem.isMandatory = false
        portTextFormItem.maxLength = 5
        let portFormItem = FormItem.text(portTextFormItem)

        let deviceIconSection = FormSection.section(
            content: [deviceIconFormItem],
            header: nil,
            footer: nil,
            mandatory: true)

        let titleSection = FormSection.section(
            content: [titleFormItem],
            header: R.string.addHost.title(),
            footer: R.string.addHost.titleDescription(),
            mandatory: true)

        let macAddressSection = FormSection.section(
            content: [macAddressFormItem],
            header: R.string.addHost.macAddress(),
            footer: R.string.addHost.macAddressDescription(),
            mandatory: true)
        
        let ipAddressScetion = FormSection.section(
            content: [ipAddressFormItem],
            header: R.string.addHost.ipAddress(),
            footer: R.string.addHost.ipAddressDescription())

        let portSection = FormSection.section(
            content: [portFormItem],
            header: R.string.addHost.port(),
            footer: R.string.addHost.portDescription())
        
        formSections =
            [deviceIconSection, titleSection, macAddressSection, ipAddressScetion, portSection]
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
