//
//  ViewModelConfigurable.swift
//  
//
//  Created by Dmitry on 27.03.2022.
//

/// Describes entity that may be configured with view model
public protocol ViewModelConfigurable {
    associatedtype ViewModel

    func configure(with: ViewModel)
}
