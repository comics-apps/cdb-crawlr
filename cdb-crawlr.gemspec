# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cdb/version'

Gem::Specification.new do |s|
  s.name    = "cdb-crawlr"
  s.version = CDB::VERSION
  s.summary = "Ruby gem and command-line tool for querying ComicBookDB.com"

  s.authors     = ["Gabe Smith"]
  s.email       = ["sgt.floydpepper@gmail.com"]
  s.date        = Time.now.strftime "%Y-%m-%d"
  s.homepage    = "https://github.com/sgtFloyd/cdb-crawlr"
  s.description = "cdb-crawlr is a Ruby gem and command-line tool for querying ComicBookDB.com"

  s.require_paths = ["lib"]
  s.files         = Dir['lib/**/*.rb']
  s.test_files    = Dir['test/**/*.rb']
  s.executables   = Dir['bin/**/*'].map{|f| File.basename(f)}

  s.add_dependency "nokogiri"
  s.add_dependency "thor", "~> 0.20"
end
