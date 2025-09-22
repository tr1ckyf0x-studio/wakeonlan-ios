//
//  Routes.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import AboutScreen
import AddHost
import DonateScreen
import HostList
import SharedRouter

/// General registry of the routes
///
/// - NOTE: New routes should be added in alphabetical order

@MainActor
extension WOLRouter: AboutScreenRoutes { }
@MainActor
extension WOLRouter: ChooseIconRoutes { }
@MainActor
extension WOLRouter: DonateScreenRoutes { }
@MainActor
extension WOLRouter: HostListRoutes { }
