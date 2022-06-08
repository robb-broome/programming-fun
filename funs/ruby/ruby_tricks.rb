# frozen_string_literal: true
require 'pry'
class RubyBlocky

  attr_accessor :instance_var

  def instance_proc(&block)
    self.instance_var = 'LOCAL'
    method_var = 'METHOD'
    instance_exec(&block)
  end

  def block_caller(&block)
    block.call
  end

  def instance_method
    puts 'this is an instance method'
  end

end


RSpec.describe RubyBlocky do
  subject(:blocky) { described_class.new }

  describe 'mutable' do
    specify 'interpolated ("dynamic") strings are mutable' do
      this = 'this'
      new_string = blocky.interpolate_my_string(this)
      expect( this).to eq('this')
      expect{ new_string << 'extra' }.not_to raise_error
      expect{ new_string << 'extra' }.not_to raise_error
      expect{ new_string.upcase! }.not_to raise_error
      new_string.freeze
      expect{ new_string.upcase! }.to raise_error(FrozenError)
    end

    it 'does not allow' do
      this = 'this'
      expect{ blocky.mutate_my_string(this) }.to raise_error(FrozenError)
    end

    it 'does allow if you unfreeze' do
      this = 'this'
      expect(this.frozen?).to be_truthy
      this = +this
      expect(this.frozen?).to be_falsey
      blocky.mutate_my_string(this)
      expect(this).to eq('THIS')
    end
  end

  describe 'calling blocks with instance_exec' do
    it 'can see instance attributes in the described_class instance' do
      expect(described_class.new.instance_proc { instance_var} ).to eq "LOCAL"
    end

    it 'cannot see local variables in the called method' do
      the_proc = proc { method_var }
      expect{ described_class.new.instance_proc( &the_proc ) }.to raise_error(NameError)
    end

    it 'sees instance methods in the class' do
      described_class.new.instance_proc {instance_method}
    end

    it 'executes procs passed' do
      a = -> {'this is defined outside the instance' * 2}
      expect(described_class.new.instance_proc(&a)).to eq(a.call)
    end

    it 'can see environment defined in the calling context' do
      a = 'this is defined outside the instance'
      expect(described_class.new.instance_proc{a}).to eq(a)
    end

    it 'cannot see methods defined in the calling context' do
      def hey
        'hey'
      end
      the_proc = proc { hey }
      expect{ described_class.new.instance_proc( &the_proc ) }.to raise_error(NameError)
    end
  end

  describe 'calling blocks with block.call' do
    it 'cannot see instance methods' do
      the_proc = proc { instance_method }
      expect{ described_class.new.block_caller( &the_proc ) }.to raise_error(NameError)
    end

    it 'can see variables defined in the calling context' do
      a = 'this is defined outside the instance'
      expect(described_class.new.block_caller {a}).to eq(a)
    end

    it 'can see methods defined in the calling context' do
      def hey
        'hey'
      end
      the_proc = proc { hey }
      expect(described_class.new.block_caller( &the_proc) ).to eq(hey)
    end

    it 'can NOT see instance attributes in the described_class instance' do
      the_proc = proc { instance_var }
      expect{ described_class.new.block_caller(&the_proc) }.to raise_error(NameError)
    end

  end
end

