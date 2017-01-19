class Enigma
  attr_reader :offsets, :rotors

  def initialize *offsets
    @offsets = offsets
  end

  def scramble word
    rotors = offsets.map{ |offset| Rotor.new(offset) }
    puts rotors
    rotor = rotors.first
    word.each_char.map do |letter|
      t = letter
      puts 't is ', t
      rotors.each do |rotor|
        t = rotor.transform(t)
        puts 't scrambled', t
      end
      puts 't out ' , t
      t
    end
  end

  class Rotor
    attr_accessor :offset

    LETTERS = *('a'..'z')

    def initialize offset
      @offset = offset
    end

    def positions
      @positions ||= Hash[ letters.zip(positions)]
    end

    def click
      offset += 1
    end

    def to_s
      "Rotor with offset = #{offset}"
    end

    def letters
      @letters ||= LETTERS.shuffle
    end

    def positions
      positions ||= *(0..25)
    end

    def mappings
      @mappings||= Hash[ positions.zip(letters)]
    end

    def transform letter
      # enter positions at letter position + offset. 
      # output is the letter from mappings at that position
      puts 'transforming', letter
      letter_position = positions[letter] + offset
      mappings[letter_position]
    end

  end
end

RSpec.describe Enigma do

  it 'scrambles' do
    e = Enigma.new(4,5,3)
    word = 'fun'
    puts e.scramble(word).inspect
  end

  it 'scrambles the same letter different ways' do
    e = Enigma.new(4,5,3)
    word = 'aaaa'
    output = e.scramble(word)
    expect(output.uniq.length).to be > 1

  end

  it 'transforms' do
    letter = 'e'
    e = Enigma::Rotor.new(4)
    expect(e.transform(letter)).not_to eq(letter)
  end
end
