#
# Copyright Devexperts (2019)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

module Objctify

  def self.collect_files(java_source_path)
    files_to_translate = ""
    Dir.glob(java_source_path + "/**/*.java") do |item|
      files_to_translate = files_to_translate + item + " "
    end
    files_to_translate
  end

  def self.translate_files(java_sources, prefix_file_path, j2objc_home, result_path)
    files_to_translate = collect_files(java_sources)

    raise Objctify::Informative, "No files to translate, check 'java_sources' parameter in Objctifile" unless files_to_translate.length > 0

    j2objcCall = "#{j2objc_home}/j2objc -source 8 --swift-friendly -Xno-source-headers -l --strip-reflection -d #{result_path} -classpath j2objc-dist/lib/jsr305-3.0.0.jar -sourcepath #{java_sources}"
    unless prefix_file_path.nil? || prefix_file_path == ""
      j2objcCall += " --prefixes #{prefix_file_path}"
    end
    j2objcCall += " #{files_to_translate}"
    call = system(j2objcCall)

    raise Objctify::Informative, "J2Objc call is unsuccessful: #{j2objcCall}" unless call
  end

end
