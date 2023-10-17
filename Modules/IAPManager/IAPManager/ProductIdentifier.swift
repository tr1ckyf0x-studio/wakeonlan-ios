//
//  ProductIdentifier.swift
//  
//
//  Created by Vladislav Lisianskii on 16.04.2023.
//

import Foundation

public enum ProductIdentifier: String, CaseIterable {
    case donateForTea = "com.tr1ckyf0x.wake_on_lan.donate.tier1"
    case donateForCoffee = "com.tr1ckyf0x.wake_on_lan.donate.tier2"
    case donateForLunch = "com.tr1ckyf0x.wake_on_lan.donate.for_lunch"
    case donateForDinner = "com.tr1ckyf0x.wake_on_lan.donate.for_dinner"
    case donateForDevelopment = "com.tr1ckyf0x.wake_on_lan.donate.for_development"
    case donateForParty = "com.tr1ckyf0x.wake_on_lan.donate.for_party"
    case donateForEquipment = "com.tr1ckyf0x.wake_on_lan.donate.for_equipment"
    case donateSignificant = "com.tr1ckyf0x.wake_on_lan.donate.significant"
}
