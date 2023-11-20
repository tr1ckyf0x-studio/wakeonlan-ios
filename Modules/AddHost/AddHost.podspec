# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'AddHost'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'AddHost',
    dependencies: %w[
        CocoaLumberjack/Swift
        CoreDataService
        SharedExtensions
        SharedProtocolsAndModels
        SharedRouter
        SnapKit
        WOLResources
        WOLUIComponents    
    ],
    submodules: %w[
        AddHostForm
        Bundle
        ChooseIcon
        Localization
    ]
)
