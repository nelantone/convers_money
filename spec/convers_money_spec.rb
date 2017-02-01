describe ConversMoney do
  it 'has a version number' do
    expect(ConversMoney::VERSION).not_to be nil
  end

  let(:money) do
    ConversMoney.conversion_rates 'EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047 }
    ConversMoney.conversion_rates 'USD', { 'EUR' => 1.14, 'btc' => 0.0011 }
    described_class.new(5, 'EUR')
  end

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

  describe '#convert_to(currency)' do
    let(:currency)        { 'USD' }
    let(:converted_money) { money.convert_to(currency) }

    it 'gives the amount as Float in cents' do
      expect(converted_money.amount).to eq(5.55)
    end

    it 'gives the same currency as the fix currency' do
      expect(converted_money.currency).to eq('USD')
    end

    it 'converted money is an instance of ConversMoney' do
      expect(converted_money).to be_an_instance_of(ConversMoney)
    end

    context 'when the currency is the same' do
      let(:same_currency)       { 'EUR' }
      let(:not_converted_money) { money.convert_to(same_currency) }

      it 'gives the same result and currency if we try to convert to the same currency' do
        expect(not_converted_money.inspect).to eql('5.00 EUR')
      end
    end
  end

  context 'operate with valid ConversMoney intances' do
    before do
      money
    end

    let(:fifty_eur)  { described_class.new(50, 'EUR') }
    let(:twenty_usd) { described_class.new(20, 'USD') }

    describe '#+' do
      let(:add_operation) { fifty_eur + twenty_usd }

      it 'expect to add variables in different currencies' do
        expect(add_operation.inspect).to eql('72.80 EUR')
      end

      it 'expect to be add_operation a ConversMoney class' do
        expect(add_operation).to be_an_instance_of(ConversMoney)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)           { ConversMoney.new(20, 'EUR') }
        let(:add_operation_in_eur) { fifty_eur + twenty_eur }

        it 'expect to add variables with the same currency' do
          expect(add_operation_in_eur.inspect).to eql('70.00 EUR')
        end
      end
    end

    describe '#-' do
      let(:substract_operation) { fifty_eur - twenty_usd }

      it 'expect to be able to substract variables in different currencies' do
        expect(substract_operation.inspect).to eql('27.20 EUR')
      end

      it 'expect to be substract_operation a ConversMoney class' do
        expect(substract_operation).to be_an_instance_of(ConversMoney)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)                 { ConversMoney.new(20, 'EUR') }
        let(:substract_operation_in_eur) { fifty_eur - twenty_eur }

        it 'expect to substract variables with the same currency' do
          expect(substract_operation_in_eur.inspect).to eql('30.00 EUR')
        end
      end
    end

    describe '#*' do
      let(:multiply_operation) { fifty_eur * twenty_usd }

      it 'expect to multiply variables in different currencies' do
        expect(multiply_operation.inspect).to eql('1140.00 EUR')
      end

      it 'expect to be multiply_operation a ConversMoney class' do
        expect(multiply_operation).to be_an_instance_of(ConversMoney)
      end

      context 'when the currency is the same' do
        let(:twenty_eur) { ConversMoney.new(20, 'EUR') }
        let(:multiply_operation_in_eur) { fifty_eur * twenty_eur }
        it 'expect to multiply variables with the same currency' do
          expect(multiply_operation_in_eur.inspect).to eql('1000.00 EUR')
        end
      end
    end

    describe '#/' do
      let(:divide_operation) { fifty_eur / twenty_usd }

      it 'expect to be able to divide variables in different currencies' do
        expect(divide_operation.inspect).to eql('2.19 EUR')
      end

      it 'expect to be divide_operation a ConversMoney class' do
        expect(divide_operation).to be_an_instance_of(ConversMoney)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)           { ConversMoney.new(20, 'EUR') }
        let(:add_operation_in_eur) { fifty_eur / twenty_eur }

        it 'expect to divide variables with the same currency' do
          expect(add_operation_in_eur.inspect).to eql('2.00 EUR')
        end
      end
    end

    describe '#==' do
      let(:fifty_eur_equal_twenty_usd)                 { fifty_eur == twenty_usd }
      let(:fifty_five_point_five_usd)                  { described_class.new(55.50, 'USD') }
      let(:fifty_five_point_five_usd_equal_fifty_eur)  { fifty_five_point_five_usd == fifty_eur }

      it 'expect to not be equal' do
        expect(fifty_eur_equal_twenty_usd).to be(false)
      end

      it 'expect to be equal' do
        expect(fifty_five_point_five_usd_equal_fifty_eur).to be(true)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)                 { ConversMoney.new(20, 'EUR') }
        let(:fifty_eur_equal_twenty_eur) { fifty_eur == twenty_eur }

        it 'expect to not be equal' do
          expect(fifty_eur_equal_twenty_eur).to eql(false)
        end
      end
    end

    describe '#>' do
      let(:fifty_eur_to_be_greater)  { fifty_eur > twenty_usd }
      let(:twenty_usd_to_be_greater) { twenty_usd > fifty_eur }

      it 'expect first value to be greater' do
        expect(fifty_eur_to_be_greater).to be(true)
      end

      it 'expect twenty_usd not to be greater than fifty_eur' do
        expect(twenty_usd_to_be_greater).to be(false)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)                        { ConversMoney.new(20, 'EUR') }
        let(:fifty_eur_greater_than_twenty_eur) { fifty_eur > twenty_eur }

        it 'expect fifty_eur to be greater than twenty_eur' do
          expect(fifty_eur_greater_than_twenty_eur).to eql(true)
        end
      end
    end

    describe '#<' do
      let(:fifty_eur_to_be_smaller)  { fifty_eur < twenty_usd }
      let(:twenty_usd_to_be_smaller) { twenty_usd < fifty_eur }

      it 'expect fifty_eur to be smaller than twenty_usd' do
        expect(fifty_eur_to_be_smaller).to be(false)
      end

      it 'expect twenty_usd not to be smaller than fifty_eur' do
        expect(twenty_usd_to_be_smaller).to be(true)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)                        { ConversMoney.new(20, 'EUR') }
        let(:fifty_eur_smaller_than_twenty_eur) { fifty_eur < twenty_eur }

        it 'expect fifty_eur not to be greater than twenty_eur' do
          expect(fifty_eur_smaller_than_twenty_eur).to eql(false)
        end
      end
    end
  end
end
