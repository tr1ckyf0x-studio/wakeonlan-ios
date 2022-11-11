//
//  Routes.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import AboutScreen
import AddHost
import HostList
import PostLaunch
import SharedRouter

/// General registry of the routes
///
/// - NOTE: New routes should be added in alphabetical order

extension WOLRouter: AboutScreenRoutes { }
extension WOLRouter: ChooseIconRoutes { }
extension WOLRouter: HostListRoutes { }
extension WOLRouter: PostLaunchRoutes { }
