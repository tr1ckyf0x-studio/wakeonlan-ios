//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class AddHostForm: Form {
    var macAddress: String?
    var ipAddress: String?
    var port: String?
    
    private(set) var formSections = [FormSection]()
    
    init() {
        configureItems()
    }
    
    private func configureItems() {
        let macAddressTextFormItem = TextFormItem()
        macAddressTextFormItem.placeholder = "00:11:22:33:44:55"
        macAddressTextFormItem.onValueChanged = { [weak self] value in
            self?.macAddress = value
        }
        macAddressTextFormItem.validator = TextValidator(strategy: AddHostValidationStrategy.macAddress)
        let macAddressFormItem = FormItem.text(macAddressTextFormItem)
        
        let ipAddressTextFormItem = TextFormItem()
        ipAddressTextFormItem.placeholder = "255.255.255.255"
        ipAddressTextFormItem.defaultValue = "255.255.255.255"
        ipAddressTextFormItem.onValueChanged = { [weak self] value in
            self?.ipAddress = value
        }
        ipAddressTextFormItem.validator = TextValidator(strategy: AddHostValidationStrategy.ipAddress)
        let ipAddressFormItem = FormItem.text(ipAddressTextFormItem)
        
        let portTextFormItem = TextFormItem()
        portTextFormItem.placeholder = "9"
        portTextFormItem.defaultValue = "9"
        portTextFormItem.onValueChanged = { [weak self] value in
            self?.port = value
        }
        portTextFormItem.validator = TextValidator(strategy: AddHostValidationStrategy.port)
        let portFormItem = FormItem.text(portTextFormItem)
        
        let macAddressSection = FormSection.section(content: [macAddressFormItem], header: "MAC ADDRESS", footer: nil)
        let ipAddressScetion = FormSection.section(content: [ipAddressFormItem], header: "IP ADDRESS", footer: nil)
        let portSection = FormSection.section(content: [portFormItem], header: "PORT", footer: nil)
        
        formSections = [macAddressSection, ipAddressScetion, portSection]
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
