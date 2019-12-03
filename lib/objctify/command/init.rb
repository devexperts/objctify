#
# Copyright Devexperts (2019)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

module Objctify
  class Command
    class Init < Command
      self.summary = 'Creates xcodeproj from java sources with j2objc' #TODO
      self.description = 'Creates xcodeproj from java source with j2objc using configuration from Objctifile' #TODO

      def run
        template_path = "#{File.dirname(__FILE__)}/../templates/Objctifile-template"
        contents = File.read(template_path)
        File.write('Objctifile', contents)

        puts 'Have fun!'
      end
    end
  end
end