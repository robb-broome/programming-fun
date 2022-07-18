# observations
# - decomposing arrays is critical
# - use Hash.new(0), not a hardcoded hash. this allows for N warehouses.
# - remember dividing integers will yield zero if < 1
# - ... my solution would not have worked because of dividing integers
# - tests added too much time to the 40 minutes allowed.

class Warehouse
  def allocate(data, requested_warehouse)
    # remember, in here we are zero-indexed
    requested_warehouse -= 1

    total_quantity = 0
    allocations = Hash.new(0)

    data.each do |order|
      quantity, *distances = order

      selected_warehouse = distances.index( distances.min )
      total_quantity += quantity

      allocations[selected_warehouse] += quantity
    end
    ((allocations[requested_warehouse].to_f / total_quantity ) * 100).to_i
  end
end

RSpec.describe Warehouse do
  subject(:allocator) { Warehouse.new }


  context 'with n warehouses' do
    let(:data) do
      [
        [2, 3, 7, 4, 90, 1],
        [4, 7, 3, 1, 90, 100],
        [2, 2, 4, 1, 90, 100],
        [2, 10,4, 4, 1,  100]
      ]
    end

    let(:warehouse) { 4 }
    let(:expected) { 20 }
    it 'gives the expected answer' do
      value = allocator.allocate(data, warehouse)
      expect(value).to eq ( expected )
    end

  end

  context 'with two warehouses' do
    let(:data) do
      [
        [2, 3, 7],
        [4, 7, 3],
        [2, 2, 4],
        [2, 10,4]
      ]
    end
    let(:warehouse) { 1 }
    let(:expected) { 40 }

    it 'gives the expected answer' do
      value = allocator.allocate(data, warehouse)
      expect(value).to eq ( expected )
    end
  end
end
