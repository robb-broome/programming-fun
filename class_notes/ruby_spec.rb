require 'pry'
# chaining safe methods
#
#
#
#
# lambdas procs blocks
# lambda is just a method which takes a block as an argument and returns a Proc

RSpec.describe 'some lambdas' do

  it 'can have > 2 args' do
    lam = lambda {|a, b, c, d| puts a, b, c, d}
    lam[1,2,3,4]
  end
  it 'checks for correct num params' do
    lam = lambda {|a, b, c, d| puts a, b, c, d}
    expect{lam[1,2,3]}.to raise_error(ArgumentError)
  end

  it 'can be defined differently' do
    lam = -> a, b, c, d { puts a, b, c, d}
    lam[1,2,3,4]
  end
end

class BasicObj < BasicObject; end

RSpec.describe BasicObject do
  let(:new_obj) { BasicObj.new }
  let(:other_obj) { BasicObj.new }

  describe 'basicness' do
    specify 'it does not have puts' do
      class BasicObj
        def i_fail_because_no_puts
          puts 'hey'
        end
      end
      new_obj = BasicObj.new
      expect{ new_obj.i_fail_because_no_puts }.to raise_error(NoMethodError)
    end
  end

  describe 'equality' do
    it 'is alwas equal to itself' do
      expect(new_obj == new_obj).to be_truthy
    end

    specify 'ids do not equal' do
      expect(new_obj.__id__).not_to equal(other_obj.__id__)
    end
    it '== is not equal if not the same object' do
      expect(new_obj == other_obj).to be_falsey
    end

    it 'equal is not equal at the objct level' do
      expect(new_obj.equal?(other_obj)).to be_falsey
    end
  end
end
# FileUtils.cd with block - what if it does not exist?
RSpec.describe FileUtils do
  let(:test_object) { double('TestObject', :hey! => true) }
  let(:existing_directory) { 'some-dir' }
  before { `mkdir #{existing_directory}` }
  after { `rm -rf #{existing_directory}`}
  context 'when the directory does not exist' do
    it 'raises' do
      my_proc = Proc.new do
        FileUtils.cd('non-existant-directory') do
          test_object.hey!
        end
      end
      expect{my_proc.call}.to raise_error(Errno::ENOENT)
    end

    it 'does not execute the code in the block' do
      my_proc = Proc.new do
        FileUtils.cd('non-existant-directory') do
          test_object.hey!
        end
      end
      expect(test_object).not_to receive(:hey!)
    end
  end

  context 'when the directory exists' do
    it 'does not raise' do
      my_proc = Proc.new do
        FileUtils.cd(existing_directory) do
          test_object.hey!
        end
      end
      expect{my_proc.call}.not_to raise_error
    end

    it 'executes the code in the block' do
      my_proc = Proc.new do
        FileUtils.cd(existing_directory) do
          test_object.hey!
        end
      end
      expect(test_object).to receive(:hey!)
      my_proc.call
    end
  end
end
