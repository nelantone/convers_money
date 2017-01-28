describe ConversMoney do
  it 'has a version number' do
    expect(ConversMoney::VERSION).not_to be nil
  end

  let(:money) do
    ConversMoney.conversion_rates('EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047})
    ConversMoney.conversion_rates('USD', { 'EUR' => 1.14, 'btc'=> 0.0011})
    described_class.new(5, 'EUR')
  end

  let(:fifty_eur) { described_class.new(50,'EUR') }
  let(:twenty_usd)     { described_class.new(20, 'USD') }


  describe '.new' do
    it 'raises an exception if its not configured' do
      expect { described_class.new(5, 'EUR') }.to raise_error(RuntimeError, /not configured/)
    end
    it 'gives a configurantion message when is well configured' do
      expect(money).to be_a(ConversMoney)
    end
  end

  describe '#amount' do
    it 'gives the quantity' do
      expect(money.amount).to eq 5
    end
  end

  describe '#currency' do
    it 'gives the quantity and the current currency' do
      expect(money.currency).to eq 'EUR'
    end
  end

  describe '#inspect' do
    it 'gives the quantity and the current currency' do
      expect(money.inspect).to eq '5.00 EUR'
    end
  end

  describe 'convert_to(currency)' do
    let(:currency) { 'USD' }
    it 'gives the amount in the converted currency' do
      expect(money.convert_to(currency)).to eq(5.55)
    end
  end

  describe '#+' do
    it 'expect to be able to add variables in different currencies' do
      expect(fifty_eur + twenty_usd).to be_eql('72.80 EUR')
    end
  end

  describe '#-' do
    it 'expect to be able to substract variables in different currencies' do
      expect(fifty_eur - twenty_usd).to be_eql('27.20 EUR')
    end
  end

  describe '#*' do
    it 'expect to be able to multiply variables in different currencies' do
      expect(fifty_eur * twenty_usd).to be_eql('1140.00 EUR')
    end
  end

  describe '#/' do
    it 'expect to be able to divide variables in different currencies' do
      expect(fifty_eur / twenty_usd).to be_eql('2.19 EUR')
    end
  end

  describe '#==' do
    it 'expect to not be equal' do
      expect(fifty_eur == twenty_usd).to be_eql(false)
    end
  end

  describe '#==' do
    let(:fifty_three_point_five_usd)     { described_class.new(53.50, 'USD') }
    it 'expect to be equal' do
      expect(fifty_eur == fifty_three_point_five_usd).to be_eql(false)
    end
  end


  describe '#>' do
    it 'expect than fifty eur to be greather twenty usd' do
      expect(fifty_eur > twenty_usd).to be_eql(true)
    end
  end


  describe '#<' do
    it 'expect twenty usd to be smaller than fifty eur ' do
      expect(twenty_usd < fifty_eur).to be_eql(true)
    end
  end
end
