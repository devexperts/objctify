#
# Copyright Devexperts (2019)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

module Objctify
  class J2ObjCPrefixes
    Prefix = Struct.new(:prefix, :wildcard)

    def initialize(prefix_file_path)
      @prefixes = Hash.new

      if !prefix_file_path.nil? && File.exists?(prefix_file_path)
        File.open(prefix_file_path).each do |line|
          if (res = line.match(/([a-zA-Z.*]+):\s+([A-Z]+)/))
            key = res[1]
            @prefixes[key.gsub(".*", "")] = Prefix.new(res[2], key.include?("*"))
          end
        end
      end
    end

      def prefix_for(path)
        key = path.gsub("/", ".")

        # searching for direct prefix
        # Fallback to looking for wildcard. if found a wildcard return it, else prefix from path
        while key.length != 0 do
          @prefixes.keys.each { |p|
            if key == p
              return @prefixes[p].prefix
            end
          }
          key, match, suffix = key.rpartition('.')
        end

        path.gsub("./", "").gsub("/", ".").split(".").map { |s| s.capitalize } * ""
      end

    end
  end
