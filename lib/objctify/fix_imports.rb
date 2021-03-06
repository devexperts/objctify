#
# Copyright Devexperts (2019)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

module Objctify

  def self.fix_imports(framework_name, prefix_file_path)
    prefixes = J2ObjCPrefixes.new(prefix_file_path)

    header_map = {}
    Dir.chdir(framework_name) do
      Pathname('.').find do |path|
        dir, base = path.split

        next unless path.file?

        prefix = prefixes.prefix_for(path.dirname.to_s)
        path.rename(dir.to_s + '/' + prefix + base.to_s)
        header_map[path.to_s.sub('./', '')] = prefix + base.to_s
      end
    end

    Dir.chdir(framework_name) do
      Pathname('.').find do |path|
        next unless path.file?

        import_reg_exp = %r{(#[a-zA-Z]+\s+"([a-zA-Z_0-9/]+.[hm]{1})")}

        text = File.read(path)
        text.scan(import_reg_exp).each do |import|

          if (mapped_import = header_map[import[1]]) && !mapped_import.nil?
            text = text.gsub(import[1], mapped_import)
          end
        end

        File.open(path, 'w') do |f|
          f.write(text)
        end
      end
    end
  end

end