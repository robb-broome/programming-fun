# in your account settings: https://app.coderpad.io/settings
require 'pry'

# This is a simple card game called War. The goal is to implement basic gameplay
# in a tested and repeatable way.

class Player
  attr_reader :name

  def initialize(name)
    @name = name
    @hand = []
  end

  def draw
    hand.pop
  end

  def take(card)
    # i own this card now
    card.owner = self
    hand.unshift(card)
  end

  def card_count
    hand.count
  end

  private

  attr_accessor :hand
end

class Round
  # play one round including handling any ties
  # set attributes for cards played
  # Don't try to figure out who's left, that is Game stuff
  #
  # A 'draw' is one time around the table where each player throws a card
  # a 'Round' may be one draw, or more than one if there is a tie between
  # some of the players.

  attr_accessor :players, :played_cards, :round_winners

  def initialize(players)
    @played_cards = []
    @players = players
    @round_winners = []
  end

  def play
    while players.count > 1
      # get a card from each player, add it to played cards
      # players who can't draw are removed
      draw_result = players.map(&:draw).compact

      # rare edge case.
      # The draw result will be nil if everybody somehow
      #   runs out of cards at the same time.
      # In that case, don't change played cards or winners
      #   or award any cards
      break if draw_result.all? nil?

      # put all the played cards into the pot
      played_cards.concat draw_result

      # reduce players to those who drew the high card for the draw
      high_card = draw_result.map(&:value).max
      high_cards_drawn = draw_result.select {|card| card.value == high_card}
      high_card_players = high_cards_drawn.map(&:owner)
      self.players = high_card_players
    end
    # Normally, just one
    self.round_winners = players
  end
end

class Game
  attr_accessor :players, :winner

  def initialize(players)
    @players = players
    @winner = nil
  end

  def play
    while players.count > 1
      round = Round.new(players)
      round.play
      round_winners = round.round_winners

      if round_winners.count == 1
        round_winner = round_winners.first
        # there is a clear winner, so award the cards
        round.played_cards.each {|card| round_winner.take(card)}

        # continue with players who have still got cards
        # NOTE: this COULD be just players who gave up a card in the last draw``
        self.players = players.select {|player| player.card_count > 0}
      else
        # ambiguous outcome, game ends
        self.players = []
      end
    end
    self.winner = players.first
  end
end

class Card

  attr_accessor :owner
  attr_reader :value

  def initialize(owner, value)
    @owner = owner
    @value = value
  end
end

RSpec.describe 'war' do
  let(:sarah) { Player.new(:sarah) }
  let(:robb) { Player.new(:robb) }
  let(:joe) { Player.new(:joe) }

  let(:sarahs_hand) { [] }
  let(:robbs_hand) { [] }
  let(:joes_hand) { [] }

  let(:players) { [sarah, robb, joe] }

  before do
    # set up initial hands
    sarahs_hand.each {|value| sarah.take( Card.new(nil, value)) }
    robbs_hand.each {|value| robb.take( Card.new(nil, value)) }
    joes_hand.each {|value| joe.take( Card.new(nil, value)) }
  end

  describe Card do
    it 'has a value' do
    end
    it 'has an owner' do
    end
  end
  describe Player do
    describe 'drawing cards' do
      let(:sarahs_hand) { [9, 10, 11] }

      it 'yields cards' do
        expect(sarah.draw).to be_a(Card)
      end

      it 'draws from the top of the players hand' do
        expect(sarah.draw.value).to eq(  9 )
        expect(sarah.draw.value).to eq( 10 )
        expect(sarah.draw.value).to eq( 11 )
      end
    end

    describe 'accepting cards' do
      let(:sarahs_hand) { [] }

      it 'assigns the card owner' do
        sarah.take(Card.new(Player.new(:noone), 11))
        expect(sarah.draw.owner).to eq( sarah )
      end

      it 'puts the accepted card on the bottom of the players hand' do
        sarah.take(Card.new(sarah, 11))
        sarah.take(Card.new(sarah, 9))
        expect(sarah.draw.value).to eq( 11 )
        expect(sarah.draw.value).to eq( 9 )
      end
    end

    describe 'when a player does not have cards' do
      let(:sarahs_hand) { [] }
      specify 'they just draw nil' do
        expect(sarah.draw).to be_nil
      end
    end

    describe 'the card count' do
      let(:sarahs_hand) { [1,2,3] }
      let(:robbs_hand) { [1,2,3] }
      let(:joes_hand) { [] }
      it 'counts correctly' do
        expect(sarah.card_count).to eq(3)
      end

      it 'counts empty hands correctly' do
        expect(joe.card_count).to eq(0)
      end
    end

  end

  describe Round do
    let(:round) { Round.new(players) }
    before { round.play }
    describe 'with one winner' do
      let(:sarahs_hand) { [9] }
      let(:robbs_hand) { [10] }
      let(:joes_hand) { [] }
      it 'returns the player who played the highest card' do
        expect(round.players).to eq([robb])
      end

      it 'returns the set of cards that were played' do
        expect(round.played_cards.map(&:value)).to match_array( [9, 10] )
      end
    end

    context 'when nobody has cards' do
      let(:sarahs_hand) { [] }
      let(:robbs_hand)  { [] }
      let(:joes_hand)   { [] }

      it 'does not blow sky high' do
        expect{round.players}.not_to raise_error
      end
    end

    context 'when there are no tie hands' do
      let(:sarahs_hand) { [4,5,8,9] }
      let(:robbs_hand)  { [3,4,7,8] }
      let(:joes_hand)   { [2,3,6,7] }

      it 'finds the correct winner' do
        expect(round.players).to eq( [sarah] )
      end
    end

    context 'when there are some ties' do
      let(:sarahs_hand) { [7,5,8,9] }
      let(:robbs_hand)  { [6,5,8,9] }
      let(:joes_hand)   { [] }
      it 'plays the tied players again to determine a round winner, then continues' do
        expect(round.players).to eq( [sarah] )
      end
    end

    describe 'with multiple winners' do
      let(:sarahs_hand) { [9] }
      let(:robbs_hand) { [9] }
      let(:joes_hand) { [] }
      it 'returns the players who played the highest card' do
        expect(round.players).to match_array([robb, sarah])
      end

      it 'returns the set of cards that were played' do
        expect(round.played_cards.map(&:value)).to match_array( [9, 9] )
      end
    end

    context  'when no players have cards' do
      let(:sarahs_hand) { [] }
      let(:robbs_hand) { [] }
      let(:joes_hand) { [] }

      it 'returns appropriate values' do
        expect(round.players).to match_array([sarah, joe, robb])
      end

      it 'returns the set of cards that were played' do
        expect(round.played_cards).to eq( [] )
      end
    end
  end

  describe Game do
    before { game.play }
    context 'when nobody has cards' do
      let(:sarahs_hand) { [] }
      let(:robbs_hand)  { [] }
      let(:joes_hand)   { [] }
      let(:game) { Game.new(players) }
      it 'does not blow sky high' do
        expect(game.winner).to be_nil
      end
    end

    context 'when there are no tie hands' do
      let(:sarahs_hand) { [4,5,8,9] }
      let(:robbs_hand)  { [3,4,7,8] }
      let(:joes_hand)   { [2,3,6,7] }
      let(:game) { Game.new(players) }
      it 'finds the correct winner' do
        expect(game.winner).to eq( sarah )
      end
    end

    context 'when the game ends in a tie' do
      let(:sarahs_hand) { [7,5,8,9] }
      let(:robbs_hand)  { [7,5,8,9] }
      let(:joes_hand)   { [] }
      let(:game) { Game.new(players) }
      specify 'nobody wins' do
        expect(game.winner).to eq( nil )
      end
    end
    context 'when there is a tie during the game' do
      let(:sarahs_hand) { [7,5,8,9] }
      let(:robbs_hand)  { [6,5,8,9] }
      let(:joes_hand)   { [] }
      let(:game) { Game.new(players) }
      it 'plays the tied players again to determine a round winner, then continues' do
        expect(game.winner).to eq(sarah)
      end
    end
  end
end

