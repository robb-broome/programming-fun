require 'spec_helper'
require 'json'

RSpec.describe RParser do
  # xit 'parses a simple string' do
  #   expect(RParser.parse('{"name": "Robb"}')).to eq({name: 'Robb'}.to_json)
  # end

  # xit 'parses a nested hash' do
  #   nested = '{"person": {"name": "Robb", "age": 45}}'
  #   expect(RParser.parse(nested)).to eq({person: {name: 'Robb', age: 45}}.to_json)
  # end

  it 'opens and closes' do
    nested = '{ }'
    RParser.parse(nested)
    nested = '{{ }}'
    RParser.parse(nested)
    nested = '{{{ }}}'
    RParser.parse(nested)
  end
end
