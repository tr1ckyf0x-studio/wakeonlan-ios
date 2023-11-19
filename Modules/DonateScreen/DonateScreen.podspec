# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'DonateScreen'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'DonateScreen',
    dependencies: %w[
        SharedRouter
        WOLResources
        WOLUIComponents
        SharedProtocolsAndModels
        IAPManager
        SnapKit
        CocoaLumberjack/Swift
        SharedExtensions
    ],
    submodules: %w[
        Bundle
        DonateScreen
        Localization
    ]
)
