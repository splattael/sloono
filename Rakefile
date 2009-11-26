require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "sloono"
  gem.summary = 'SMS API for sloono.de'
  gem.email = "peter-sloono@suschlik.de"
  gem.homepage = "http://github.com/splattael/sloono"
  gem.authors = ["Peter Suschlik"]

  gem.has_rdoc = true
  gem.extra_rdoc_files = [ "README.rdoc" ]

  gem.add_dependency "typhoeus", ">= 0.1.10"

  gem.add_development_dependency "riot", "= 0.10.1"

  gem.test_files = Dir.glob('test/test_*.rb')
end

Jeweler::GemcutterTasks.new

# Test
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/test_*.rb')
  test.libs << 'test'
  test.verbose = true
end

# RDoc
Rake::RDocTask.new do |rd|
  rd.title = "Sloono SMS API"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/*.rb")
  rd.rdoc_dir = "doc"
end


# Misc
desc "Tag files for vim"
task :ctags do
  dirs = $LOAD_PATH.select {|path| File.directory?(path) }
  system "ctags -R #{dirs.join(" ")}"
end

desc "Find whitespace at line ends"
task :eol do
  system "grep -nrE ' +$' *"
end
