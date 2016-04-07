require 'rubygems'
require 'rspec'
require 'pry'

require_relative '../bm.rb'

spec_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift spec_dir

RSpec.configure do |config|
end
