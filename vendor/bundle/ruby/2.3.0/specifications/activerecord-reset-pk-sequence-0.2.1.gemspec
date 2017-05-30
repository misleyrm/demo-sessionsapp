# -*- encoding: utf-8 -*-
# stub: activerecord-reset-pk-sequence 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "activerecord-reset-pk-sequence"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Enrique Garcia Cota", "Thomas Kienlen", "Francisco Juan"]
  s.date = "2016-05-15"
  s.description = "Id of an AR table cleaner. Works for Postgres and Sqlite."
  s.email = "francisco.juan@gmail.com"
  s.homepage = "https://github.com/fjuan/activerecord-reset-pk-sequence"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Allows resetting the id of an AR table to 0. Useful after a delete_all. Works in Postgres and Sqlite (not MySQL) for now."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["> 0", "~> 0"])
    else
      s.add_dependency(%q<rake>, ["> 0", "~> 0"])
    end
  else
    s.add_dependency(%q<rake>, ["> 0", "~> 0"])
  end
end
