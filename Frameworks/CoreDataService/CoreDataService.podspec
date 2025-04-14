# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'CoreDataService'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Service which provides basic core data functionality',
    dependencies: %w[
        CocoaLumberjack/Swift
        SharedProtocolsAndModels
        FoxCoreDataService
    ],
    submodules: %w[
        Bundle
        Core
        Migrations
        Models
        Workers
    ]
)
