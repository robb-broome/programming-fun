require 'spec_helper'

RSpec.describe 'array_comparator' do
  describe 'builds arrays' do
    let(:length) {10}

    it 'of type Array' do
      expect( ar(length) ).to be_instance_of(Array)
    end

    it 'with the length requested' do
      expect(ar(length).length).to eq(length)
    end

    describe 'with certain properties' do
      let(:size) { 10_000 }
      let(:repititions) { 5 }

      it 'is sorted' do
        repititions.times do
          array = ar( size )
          last_value = array.shift
          loop do
            next_value = array.shift
            break if next_value.nil?
            expect( next_value ).to be > last_value
            last_value = next_value
          end
        end
      end

      it 'has unique values' do
        repititions.times do
          array = ar( size )
          last_value = array.shift
          loop do
            next_value = array.shift
            break if next_value.nil?
            expect( next_value ).not_to eq(last_value)
            last_value = next_value
          end
        end
      end
    end
  end

  describe 'finds shared values' do
    context 'with large arrays' do
      let(:length) { 10_000 }
      let(:a) { ar( length ) }
      let(:b) { ar( length ) }
      let!(:intersection) { a & b }

      specify 'fast algo' do
        expect( fast( a, b ) ).to eq intersection
      end
      specify 'slow algo' do
        expect( slow( a, b ) ).to eq intersection
      end
    end

    context 'with small arrays' do
      let(:a) { [1, 3, 5, 7, 9, 11] }
      let(:b) { [0, 3, 4, 7, 8, 11] }
      let!(:intersection) { a & b }

      specify 'fast algo' do
        expect( fast( a, b ) ).to eq intersection
      end

      specify 'slow algo' do
        expect( slow( a, b ) ).to eq intersection
      end
    end
  end
end
