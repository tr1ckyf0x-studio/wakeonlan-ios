# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'WakeOnLanService'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Implementation of the wake on lan protocol',
    dependencies: %w[
        SharedProtocolsAndModels
    ],
    submodules: %w[
        MagicPacketBuilder
        NWConnectionBuilder
        UDPService
        WOLService
    ]
)
