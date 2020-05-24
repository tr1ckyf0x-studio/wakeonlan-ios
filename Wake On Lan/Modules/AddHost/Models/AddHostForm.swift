//
//  AddHostForm.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class AddHostForm: Form {
    var title: String?
    var macAddress: String?
    var ipAddress: String?
    var port: String?
    
    private(set) var formSections = [FormSection]()
    
    init() {
        configureItems()
    }
    
    private func configureItems() {
        // TODO: Image picker form item
        
        let titleTextFormItem = TextFormItem()
        titleTextFormItem.onValueChanged = { [weak self] value in
            self?.title = value
        }
        titleTextFormItem.validator = TextValidator(strategy: AddHostValidationStrategy.title)
        let titleFormItem = FormItem.text(titleTextFormItem)
        
        let macAddressTextFormItem = TextFormItem()
        macAddressTextFormItem.placeholder = "XX:XX:XX:XX:XX:XX"
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
        
        let titleSection = FormSection.section(content: [titleFormItem], header: R.string.addHost.title(), footer: nil)
        let macAddressSection = FormSection.section(content: [macAddressFormItem], header: R.string.addHost.macAddress(), footer: nil)
        let ipAddressScetion = FormSection.section(content: [ipAddressFormItem], header: R.string.addHost.ipAddress(), footer: nil)
        let portSection = FormSection.section(content: [portFormItem], header: R.string.addHost.port(), footer: nil)
        
        formSections = [titleSection, macAddressSection, ipAddressScetion, portSection]
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
