# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'SharedProtocolsAndModels'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Common models and protocols which can be used across modules',
    dependencies: %w[
    ],
    submodules: %w[
        AddHost
        BundleConstants
        FileManager
        GeneratesFeedback
        HostRepresentable
        Mandatoryable
        OpensURL
        ProvidesCollectionViewCell
        ProvidesTableViewCell
        ProvidesSharedInstance
        RequestsReview
        SFSymbol
        Validable
        ViewModelConfigurable
    ]
)
