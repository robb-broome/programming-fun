# in your account settings: https://app.coderpad.io/settings
require 'pry'

# This is a simple card game called War. The goal is to implement basic gameplay
# in a tested and repeatable way.

class Player
  attr_reader :name, :hand

  def initialize(name, hand)
    @name = name
    @hand = hand || []
  end

  def draw
    [ self, hand.pop ]
  end

  def take(card)
    hand.unshift(card)
  end

  def card_count
    hand.count
  end
end

class Round
  # play one round including handling any ties
  # set attributes for cards played
  # Don't try to figure out who's left, that is Game stuff
  #
  # A 'draw' is one time around the table where each player throws a card
  # a 'Round' may be one draw, or more than one if there is a tie between
  # some of the players.

  attr_accessor :players, :played_cards

  def initialize(players)
    @played_cards = []
    @players = players
  end

  def play
    while players.count > 1
      # get a card from each player, add it to played cards
      # players who can't draw are removed
      draw_result = players.map(&:draw).delete_if {|item| item[1].nil?}
      drawn_cards = draw_result.map {|item| item[1]}
      # put all the played cards into the pot
      played_cards.concat drawn_cards

      # rare edge case: draw result will be nil if everybody somehow runs out of cards at the
      # same time. in that case, don't change played cards or winners
      break if draw_result.all? nil?

      # reduce players to those who drew the high card for the draw
      high_card = drawn_cards.max
      self.players = draw_result.select {|item| item[1] == high_card}.map {|item| item[0]}
    end
  end
end

class Game
  attr_accessor :players

  def initialize(players)
    @players = players
  end

  def play
    while players.count > 1
      round = Round.new(players)
      round.play
      winners = round.players

      if winners.count == 1
        # there is a clear winner, so award the cards
        winner = winners.first
        # award the winner all the played cards
        round.played_cards.each {|card| winner.take(card)}
      end

      self.players = players.select {|player| player.card_count > 0}

      # this happens if all active players had
      # precisely the same hand, in the same order
      # .. then, everyone has drawn all their cards
      # and all the cards are in the pot. Nobody will get these.
      # in this case, nobody can win and it's over
      break if players.count == 0

    end
    players
  end
end

RSpec.describe 'war' do
  let(:sarah) { Player.new(:sarah, sarahs_hand) }
  let(:sarahs_hand) { [] }
  let(:robb) { Player.new(:robb, robbs_hand) }
  let(:robbs_hand) { [] }
  let(:joe) { Player.new(:joe, joes_hand) }
  let(:joes_hand) { [] }

  let(:players) { [sarah, robb, joe] }

  describe Player do
    describe 'drawting cards' do
      let(:sarahs_hand) { [9, 10, 11] }
      it 'draws from the top of the players hand' do
        expect(sarah.draw).to eq( [ sarah, 11 ] )
        expect(sarah.draw).to eq( [ sarah, 10 ] )
        expect(sarah.draw).to eq( [ sarah, 9 ] )
      end
    end

    describe 'accepting cards' do
      let(:sarahs_hand) { [9] }
      it 'puts the accepted card on the bottom of the players hand' do
        sarah.take(11)
        expect(sarah.draw).to eq( [sarah, 9] )
        expect(sarah.draw).to eq( [sarah, 11] )
      end
    end

    describe 'when a player does not have cards' do
      let(:sarahs_hand) { [] }
      specify 'they just draw nil' do
        expect(sarah.draw).to eq( [sarah, nil] )
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
        expect(round.played_cards).to match_array( [9, 10] )
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
        expect(round.played_cards).to match_array( [9, 9] )
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
        expect(round.played_cards).to match_array( [] )
      end
    end
  end

  describe Game do
    context 'when nobody has cards' do
      let(:sarahs_hand) { [] }
      let(:robbs_hand)  { [] }
      let(:joes_hand)   { [] }
      let(:game) { Game.new(players) }
      it 'does not blow sky high' do
        expect(game.play).to eq( [] )
      end
    end
    context 'when there are no tie hands' do
      let(:sarahs_hand) { [4,5,8,9] }
      let(:robbs_hand)  { [3,4,7,8] }
      let(:joes_hand)   { [2,3,6,7] }
      let(:game) { Game.new(players) }
      it 'finds the correct winner' do
        expect(game.play).to eq( [sarah] )
      end
    end

    context 'when the game ends in a tie' do
      let(:sarahs_hand) { [7,5,8,9] }
      let(:robbs_hand)  { [7,5,8,9] }
      let(:joes_hand)   { [] }
      let(:game) { Game.new(players) }
      specify 'nobody wins' do
        expect(game.play).to eq( [] )
      end
    end
    context 'when there is a tie during the game' do
      let(:sarahs_hand) { [7,5,8,9] }
      let(:robbs_hand)  { [6,5,8,9] }
      let(:joes_hand)   { [] }
      let(:game) { Game.new(players) }
      it 'plays the tied players again to determine a round winner, then continues' do
        expect(game.play).to eq([sarah])
      end
    end
  end
end

