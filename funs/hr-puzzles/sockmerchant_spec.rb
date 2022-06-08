require 'pry'
def sockMerchant(n, ar)
  result = Hash.new {|h,k| h[k] = 0}
  binding.pry
  counts = ar.each.reduce(result) do |memo, sock_color|
    puts "memo: #{memo}, sock_color: #{sock_color}"
    memo[sock_color] += 1
    memo
  end
  puts 'counts'
  puts counts.inspect
  counts.keep_if {|color, count| count / 2 > 0 }
  counts.keys.count
end

RSpec.describe 'sockMerchant' do
  let(:pile) { '10 20 20 10 10 30 50 10 20'.split(' ').map(&:to_i) }
  let(:n) { 9 }

  it 'works' do
    expect(sockMerchant(n, pile)).to eq(3)
  end
end
