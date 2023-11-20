# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'WOLUIComponents'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'UI Components',
    dependencies: %w[
        SharedProtocolsAndModels
        SharedExtensions
        SnapKit
        WOLResources
    ],
    submodules: %w[
        Elements
        SoftUI
    ]
)
