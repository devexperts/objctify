#
# Copyright Devexperts (2019)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

require 'xcodeproj'

module Objctify

  def self.generate_project(framework_name, j2objc_home)
    project = Xcodeproj::Project.new("#{framework_name}.xcodeproj")
    target = project.new_target(:framework, framework_name, :ios)

    source_build_phase = target.source_build_phase
    headers_build_phase = target.headers_build_phase

    #add files
    Pathname(framework_name).find do |path|
      dir, base = path.split
      if path.directory?

        if path.to_s == framework_name
          project.new_group base.to_s, base
        else
          group_to_append_to = project[dir.to_s]
          group_to_append_to.new_group base.to_s, base
        end

      elsif path.file?

        group = project[dir.to_s]
        new_ref = group.new_reference base

        if new_ref.last_known_file_type == 'sourcecode.c.h'
          build_file = headers_build_phase.add_file_reference new_ref
          build_file.settings = { ATTRIBUTES: ['', 'Public'] }
        elsif new_ref.last_known_file_type == 'sourcecode.c.objc'
          source_build_phase.add_file_reference new_ref
        end

      end
    end

    header_file_path = Pathname("#{framework_name}/#{framework_name}.h")

    File.open(header_file_path, 'w') do |header_file|
      header_template = "//
//  #{framework_name}.h
//  #{framework_name}
//
//

#import <UIKit/UIKit.h>

//! Project version number for #{framework_name}.
FOUNDATION_EXPORT double #{framework_name}VersionNumber;

//! Project version string for #{framework_name}.
FOUNDATION_EXPORT const unsigned char #{framework_name}VersionString[];

"

      header_file.write(header_template)
      header_file.write(headers_build_phase.files_references.map(&:path).map { |header_file_name| "#include <#{framework_name}/" + header_file_name + '>' } * "\n")
    end

    dir, base = header_file_path.split

    header_file_ref = project[dir.to_s].new_reference base
    header_build_file = headers_build_phase.add_file_reference header_file_ref
    header_build_file.settings = { ATTRIBUTES: ['', 'Public'] }

    project.targets.each do |target|
      target.add_system_library_tbd(%w[z iconv])
      target.add_system_framework('UIKit')

      path = File.expand_path("#{j2objc_home}/frameworks/JRE.framework")
      unless (ref = project.frameworks_group.find_file_by_path(path))
        ref = project.frameworks_group.new_file(path, :absolute)
      end
      target.frameworks_build_phase.add_file_reference(ref, true)

      target.build_configurations.each do |config|
        config.build_settings['CLANG_ENABLE_OBJC_ARC'] = false
        config.build_settings['FRAMEWORK_SEARCH_PATHS'] = "#{j2objc_home}/frameworks"
        config.build_settings['HEADER_SEARCH_PATHS'] = "#{j2objc_home}/frameworks/JRE.framework/Headers"

        # Workaround
        config.build_settings['SUPPORTS_MACCATALYST'] = false
      end
    end

    project.save
  end

end
