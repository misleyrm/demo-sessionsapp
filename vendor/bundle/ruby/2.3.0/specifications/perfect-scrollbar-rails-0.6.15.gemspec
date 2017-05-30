# -*- encoding: utf-8 -*-
# stub: perfect-scrollbar-rails 0.6.15 ruby lib

Gem::Specification.new do |s|
  s.name = "perfect-scrollbar-rails"
  s.version = "0.6.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Guillaume Hain"]
  s.date = "2016-12-10"
  s.description = "Make perfect-scrollbar available to Rails"
  s.email = ["zedtux@zedroot.org"]
  s.homepage = "https://github.com/YourCursus/perfect-scrollbar-rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "This Gem integrates noraesae's Jquery perfect-scrollbar with Rails, exposing its JavaScript and CSS assets via a Rails Engine."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["< 6.0", ">= 3.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<railties>, ["< 6.0", ">= 3.2"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, ["< 6.0", ">= 3.2"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
