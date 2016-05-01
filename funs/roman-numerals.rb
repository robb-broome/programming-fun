require 'rspec'
RSpec.describe Roman do
 it 'turns III into 3' do
   expect(Roman.dec_for('III').to eq(3)
 end
end

class Roman
class << self
  def dec_for numeral
  end
end
end
