# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'WakeOnLanService'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'WakeOnLanService',
    dependencies: %w[
        SharedProtocolsAndModels
    ],
    submodules: %w[
        WakeOnLanService
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
