require 'spec_helper'
require 'json'

RSpec.describe RParser do
 # it 'parses a simple string' do
 #   val = RParser.parse('{"name": "Robb"}')

 #   binding.pry
 #    expect(val).to eq({name: 'Robb'}.to_json)
 #  end
  #
  # it 'parses a hash with two keys' do
  #   test = '{"name": "Robb", "age": 45}'
  #   expect(RParser.parse(test)).to eq({name: 'Robb', age: 45}.to_json)
  # end

  # it 'parses a nested hash' do
  #   test = '{"person": {"name": "Robb", "age": 45}}'
  #   expect(RParser.parse(test)).to eq({person: {name: 'Robb', age: 45}}.to_json)
  # end

  # it 'opens and closes' do
  #   nested = '{ }'
  #   RParser.parse(nested)
  #   nested = '{{ }}'
  #   RParser.parse(nested)
  #   nested = '{{{ }}}'
  #   RParser.parse(nested)
  # end
end
