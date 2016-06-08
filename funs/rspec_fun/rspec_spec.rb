require 'rspec'

RSpec.describe 'it caches, right?' do
  let(:uuid) { SecureRandom.uuid }
  it 'caches, right?' do
    puts uuid
  end
  it 'caches, right?' do
    puts uuid
  end
end

