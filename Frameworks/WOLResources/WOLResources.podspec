# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'WOLResources'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Resources module',
    dependencies: %w[
        SharedProtocolsAndModels
    ],
    submodules: %w[
        Assets
        Bundle
        WOLResources
    ]
)
