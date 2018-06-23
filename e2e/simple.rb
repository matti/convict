require "bundler/setup"
require "convict"

jail = Convict::Jail.new "spec/tests/simple/simple.rb"
jail.run
