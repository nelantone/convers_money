RSpec.describe ConversMoney::Money do
  let!(:money) do
    described_class.new(5, 'EUR')
  end

  # shared_context "shared config" do
  #   before do
  #     @shared_config = ConversMoney.conversion_rates('EUR', { 'USD' => 2})
  #   end
  # end

  describe '.new' do
    it 'raises an exception if its not configured' do
      expect { described_class.new }.to raise_error(RuntimeError, /not configured/)
    end
    it 'gives a configurantion message when is well configured' do
      expect ( described_class.new ).to be("Config it's ready. Well done")
    end
  end

  describe '#amount' do
    # include_context "shared config"
    # @shared_config
    before do
      ConversMoney.conversion_rates('EUR', { 'USD' => 2})
    end
    it "gives the quantity" do
      expect(money.amount).to eq 5
    end
  end

  describe '#currency' do
    before do
      ConversMoney.conversion_rates('EUR', { 'USD' => 2})
    end
    it 'gives the quantity and the current currency' do
      expect(money.currency).to eq 'EUR'
    end
  end

  describe '#inspect' do
    before do
      ConversMoney.conversion_rates('EUR', { 'USD' => 2})
    end
    it 'gives the quantity and the current currency' do
      expect(money.inspect).to eq '5 EUR'
    end
  end

end


