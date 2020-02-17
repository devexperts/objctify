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
      @prefixes = {}

      return unless !prefix_file_path.nil? && File.exist?(prefix_file_path)

      File.open(prefix_file_path).each do |line|
        if (res = line.match(/([a-zA-Z.*]+):\s+([A-Z]+)/))
          key = res[1]
          @prefixes[key.gsub('.*', '')] = Prefix.new(res[2], key.include?('*'))
        end
      end
    end

    def prefix_for(path)
      key = path.gsub('/', '.')

      # searching for direct prefix
      # Fallback to looking for wildcard. if found a wildcard return it, else prefix from path
      until key.empty?
        @prefixes.keys.each do |p|
          return @prefixes[p].prefix if key == p
        end
        key, = key.rpartition('.')
      end

      path.gsub('./', '').gsub('/', '.').split('.').map(&:capitalize) * ''
    end

  end
end
