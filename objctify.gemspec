lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "objctify/version"

Gem::Specification.new do |spec|
  spec.name          = "objctify"
  spec.version       = Objctify::VERSION
  spec.license       = 'MPL-2.0'
  spec.authors       = ["Devexperts"]
  spec.email         = ["opensource@devexperts.com"]

  spec.summary       = %q{Automates translation of Java sources into Objective-C using J2ObjC tool by Google}
  spec.description   = %q{A gem which helps you literally use Java on iOS. It is a wrapper of J2ObjC tool by Google, which handles the most of
routine actions. Basically it turns your Java sources into an iOS framework ready to use in you iOS projects.}
  spec.homepage      = %q{https://github.com/devexperts/objctify}

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|pkg|example)/})
  end
  spec.executables   = %w(objctify)
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'claide', '< 2.0', '>= 0.9.1'
  spec.add_dependency 'xcodeproj', '< 2.0.0', '>= 1.3.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
