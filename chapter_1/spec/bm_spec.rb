require 'spec_helper'

RSpec.describe 'Chapter 1' do
  describe 'string' do
    let(:unique_string) {'abcdefghi' }
    let(:duplicated_string) {'abcdeefghi' }
    let(:unsorted_duplicated_string) {'abacdefghi' }

    describe 'shift' do
      it 'gets the first char' do
        expect(unique_string.unshift).to eq('a')
      end
      it 'mutates the string' do
        skip 'because it doesn\'t'
        unique_string.unshift
        expect(unique_string).to eq('bcdefghi')
      end
    end
    describe 'unique string' do

      it 'finds that the unique string is unique' do
        expect( unique?(unique_string) ).to be_truthy
      end

      it 'finds that the non-unique string is not unique' do
        expect( unique?(duplicated_string) ).to be_falsey
      end

      it 'finds that the unsorted non-unique string is not unique' do
        expect( unique?(unsorted_duplicated_string) ).to be_falsey
      end
    end

    describe 'rotate' do
      let(:small_string) {'abc'}
      it 'rotates' do
        expect(small_string.rotate(1)).to eq('bca' )
      end
      it 'rotates 2' do
        expect(small_string.rotate(2)).to eq('cab' )
      end
      it 'rotates 3' do
        expect(small_string.rotate(3)).to eq('abc' )
      end
      it 'rotates 4' do
        expect(small_string.rotate(4)).to eq('bca' )
      end
      it 'rotates 300' do
        expect(small_string.rotate 300 ) .to eq('abc' )
      end
      it 'rotates 301' do
        expect(small_string.rotate 301 ).to eq('bca' )
      end
    end

    describe 'is_rotation_of?' do
      let(:string) {'abcdef'}
      let(:rotated) {'abcdef'.rotate(2)}
      let(:not_rotated) {'def123'}

      it 'finds an equal string' do
        expect(string.is_rotation_of? string.dup ).to be_truthy
      end

      it 'finds a rotated string' do
        expect(string.is_rotation_of? rotated ).to be_truthy
      end

      it 'finds a non-rotated string' do
        expect(string.is_rotation_of? not_rotated ).to be_falsey
      end

      it 'is false if other is not the same length' do
        expect(string.is_rotation_of? 'abc' ).to be_falsey
      end

    end
  end
  describe 'matrix' do

    describe 'rotation' do
    end

  end
end
