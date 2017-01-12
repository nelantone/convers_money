RSpec.describe ConversMoney::Money do
  let!(:money) do
    described_class.new(5, 'EUR')
  end
  
  describe '.new' do
    it 'raises an exception if its not configured' do
      expect { described_class.new }.to raise_error(RuntimeError, /not configured/)
    end
  end

  describe '#amount' do
    before do
      ConversMoney.conversion_rates('EUR', { 'USD' => 2})
    end
    it "gives the quantity" do
      expect(money.amount).to eq 5
    end
  end

  describe '#inspect' do
  end

  describe '#currency' do
  end

end


