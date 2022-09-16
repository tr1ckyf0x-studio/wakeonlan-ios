//
//  AboutScreenViewViewModel.swift
//  
//
//  Created by Dmitry on 08.08.2021.
//
struct AboutScreenViewViewModel {
    /// Represents header view
    /// sourcery: AutoEquatable
    let headerViewModel: AboutScreenHeaderViewViewModel
    /// Represents list of buttons
    let buttonListViewModel: [AboutScreenMenuButtonViewViewModel]
}
