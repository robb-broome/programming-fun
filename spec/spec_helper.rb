require 'rubygems'
require 'rspec'
require 'pry'

fi = Dir[File.expand_path('funs/*/*.rb')]
fi.each {|file| require file}

spec_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift spec_dir

RSpec.configure do |config|
    config.default_formatter = 'doc'
  config.order = :random
end
