class Solution
  attr_accessor :giftcard_amount, :catalog
  def initialize(giftcard_amount: 0, catalog: [])
    @giftcard_amount = giftcard_amount
    @catalog = catalog
  end

  def buy_stuff
    catalog.sort.reverse.map do |item|
      # buy the item if the giftcard can afford
      number_to_buy = giftcard_amount / item
      puts "giftcard balance before purchase #{giftcard_amount}"
      puts "buying #{number_to_buy} of item #{item} for #{number_to_buy * item}"
      self.giftcard_amount -= (number_to_buy * item)
      puts "giftcard balance after purchase #{giftcard_amount}"
      break if giftcard_amount <= 0
      Array.new(number_to_buy, item)
    end.flatten

  end
end


RSpec.describe Solution do
  subject { Solution.new(giftcard_amount: 15, catalog: [2,3,5,7]) }

  it 'takes a giftcard amount' do
    expect(subject).to be_a(Solution)
  end

  it 'returns catalog items that add up to the giftcard amount' do
    expect(subject.buy_stuff).to match_array([7,3,5])
  end
end
