# frozen_string_literal: true

require 'cocoapods-core/specification'

module PodUtils
    def self.defmodule(
        name:,
        summary:,
        dependencies: [],
        description: summary,
        module_path: '',
        submodules: [],
        version: '1.0',
        need_create_mock_spec: false,
        need_create_test_spec: true
      )
        Pod::Spec.new do |spec|
            spec.name = name
            spec.summary = summary
            spec.description = description
            spec.author = "Vladislav Lisianskii"
            spec.homepage = 'https://github.com/tr1ckyf0x/wakeonlan-ios'
            spec.platform = :ios, '13.0'
            spec.version = version
            spec.source = { :git => '' }
            spec.license = license

            dependencies.each { |dep| spec.dependency dep }            

            add_mock(spec: spec, module_path: module_path) if need_create_mock_spec
            add_resource_bundle(spec: spec, module_path: module_path)
            add_seed(spec: spec, module_path: module_path) if need_create_mock_spec
            add_test(spec: spec, module_path: module_path) if need_create_test_spec

            submodules.each { |submodule| add_submodule(spec: spec, module_path: module_path, submodule: submodule) }

            yield spec if block_given?
        end
    end

    # Creates submodule
    def self.add_submodule(spec:, module_path:, submodule:)
        submodule_name = submodule
        spec.subspec submodule_name do |subspec|
            module_path_prefix = module_path_prefix(module_path: module_path, submodule_name: submodule_name)
            subspec.source_files = "#{module_path_prefix}**/*.{swift,h,m,mm,c}"
            exclude(spec: subspec, module_path: module_path, submodule_name: submodule_name)
        end
    end

    # Creates Test podspec
    def self.add_test(spec:, module_path: '', submodule_name: '')
        spec.test_spec 'Tests' do |test_spec|
        module_path_prefix = module_path_prefix(module_path: module_path, submodule_name: submodule_name)

        test_spec.dependency 'TestAdditions'
        test_spec.test_type = :unit
        test_spec.scheme = {
            code_coverage: true
        }
        test_spec.source_files = [
            "#{module_path_prefix}**/*Tests.swift",
        ]
        end
    end

    # Creates Mock podspec
    def self.add_mock(spec:, module_path: '', submodule_name: '')
        spec.subspec 'Mock' do |subspec|
        module_path_prefix = module_path_prefix(module_path: module_path, submodule_name: submodule_name)

        subspec.source_files = [
            "#{module_path_prefix}**/*Mock.swift",
            "#{module_path_prefix}**/*Mocks.swift"
        ]
        end
    end

    # Creates resources bundle
    def self.add_resource_bundle(spec:, module_path: '')
       module_name = ''
       module_path_prefix = module_path_prefix(module_path: module_path)

       if module_path == ''
         podspec_folder = Dir.pwd
         module_name = Pathname(podspec_folder).each_filename.to_a.last
       else
         module_name = module_path.split('/').drop(1).join('/')
       end

       resources_path_prefix = module_path_prefix == '' ? '' : module_path_prefix.to_s
       resource_bundle = {}

       unless Dir["#{resources_path_prefix}Resources/ModuleData/"].empty?
         resource_bundle["#{module_name}Resources"] = "#{resources_path_prefix}Resources/ModuleData/*"
       end

       spec.resource_bundle = resource_bundle
     end

    # Creates Seed podspec
    def self.add_seed(spec:, module_path: '', submodule_name: '')
        spec.subspec 'Seed' do |subspec|
        module_path_prefix = module_path_prefix(module_path: module_path, submodule_name: submodule_name)
        subspec.source_files = [
            "#{module_path_prefix}**/*Seeds.swift"
        ]
        end
    end

    # Files excluded from release
    def self.exclude(spec:, module_path: '', submodule_name: '')
        module_path_prefix = module_path_prefix(module_path: module_path, submodule_name: submodule_name)
        spec.exclude_files = [
            "#{module_path_prefix}**/*Mock.swift",
            "#{module_path_prefix}**/*Mocks.swift",
            "#{module_path_prefix}**/*Seeds.swift",
            "#{module_path_prefix}**/*Tests.swift"
        ]
    end

    # Example: Frameworks/SharedServices/Chat/ or Frameworks/SharedServices/
    def self.module_path_prefix(module_path:, submodule_name: '')
        prefix = ''
        prefix = "#{module_path}/" if module_path != ''
        prefix += "#{submodule_name}/" if submodule_name != ''
        prefix
    end

    # Describes license
    # TODO: Text should be changed according to the appropriate license
    def self.license
        date = Time.new
        year = date.year
        {
            type: 'Custom',            
            text: <<~LICENSE
                Copyright #{year}
            LICENSE
        }
    end
end
