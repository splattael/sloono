
def run(*args)
  system("ruby -rubygems -Ilib:test #{args.join(' ')}")
end

watch( 'test/test_.*\.rb' )  {|md| run md[0] }
watch( 'lib/(.*)\.rb' )      {|md| run "test/test_#{md[1]}.rb" }

