describe ConversMoney do
  it 'has a version number' do
    expect(ConversMoney::VERSION).not_to be nil
  end

  let(:money) do
    ConversMoney.conversion_rates 'EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047 }
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
        expect(not_converted_money).to have_attributes(:amount => 5.00, :currency => 'EUR')
      end
    end
  end

  context 'operate with valid ConversMoney intances' do
    before do
      ConversMoney.conversion_rates 'EUR', { 'USD' => 1.11, 'BTC' => 0.0047 }
    end

    let(:fifty_eur)  { described_class.new(50, 'EUR') }
    let(:twenty_usd) { described_class.new(20, 'USD') }

    describe '#+' do
      let(:add_operation)                     { twenty_usd + fifty_eur }

      it 'expect add_operation to return a ConversMoney class/instance' do
        expect(add_operation).to be_an_instance_of(ConversMoney)
      end

      it 'expect to add variables in different currencies' do
        expect(add_operation).to have_attributes( :amount => 75.50  , :currency => 'USD')
      end

      context 'when we invert the constant conversion rate' do
        let(:add_inverse_currency_operation)             { fifty_eur + twenty_usd }
        let(:one_btc)                                    { ConversMoney.new( 1, 'BTC')}
        let(:add_other_inverse_instance_with_an_integer) { one_btc + 200 }

        it 'expect to add none fixed rate variables inverting conversion rates' do
          expect(add_inverse_currency_operation).to have_attributes( :amount => 68.02, :currency =>'EUR')
        end

        it 'expect to add bitcoins with floats as other inverting conversion rate' do
          expect(add_other_inverse_instance_with_an_integer).to have_attributes( :amount => 201, :currency =>'BTC')
        end

        it 'expect add_inverse_currency_operation to return a ConversMoney class' do
          expect(add_inverse_currency_operation).to be_an_instance_of(ConversMoney)
        end
      end

      context 'when we have a float' do
        let(:add_instance_with_a_float)    { twenty_usd + 20.00 }
        let(:add_instance_with_an_integer) { twenty_usd + 20 }

        it 'expect to add an instance with a float' do
          expect(add_instance_with_a_float).to have_attributes( :amount => 40.0, :currency =>'USD')
        end

        it 'expect to add an inverse currency instance with some float' do
          expect(add_instance_with_an_integer).to have_attributes( :amount => 40, :currency =>'USD')
        end
      end

       context 'when we have an integer' do
        let(:add_instance_with_an_integer)              { twenty_usd + 20 }
        let(:total_amount_attribute_class)              { add_instance_with_an_integer.amount.class }

        it 'expect to add an ConversMoney amount attribute to be an integer' do
          expect(total_amount_attribute_class).to be(Fixnum)
        end
       end

      context 'when the currency is the same' do
        let(:twenty_eur)           { ConversMoney.new(20, 'EUR') }
        let(:add_operation_in_eur) { fifty_eur + twenty_eur }

        it 'expect to add variables with the same currency' do
          expect(add_operation_in_eur).to have_attributes( :amount => 70.00, :currency => 'EUR')
        end
      end
    end

    describe '#-' do
      let(:substract_operation)                  { fifty_eur - twenty_usd }
      let(:substract_instance_with_a_float)      { twenty_usd - 20.00 }
      let(:substract_inverse_currency_operation) { fifty_eur - twenty_usd }
      let(:substract_instance_with_an_integer)   { twenty_usd - 20 }
      let(:total_amount_attribute_class)         { substract_instance_with_an_integer.amount.class }

      it 'expect to substract none fixed rate variables inverting conversion rates' do
        expect(substract_inverse_currency_operation).to have_attributes(:amount => 31.98, :currency =>'EUR')
      end

      it 'expect to substract variables in different currencies' do
        expect(substract_operation).to have_attributes(:amount => 31.98, :currency =>'EUR')
      end

      it 'expect substract_operation to be ConversMoney class/instance' do
        expect(substract_operation).to be_an_instance_of(ConversMoney)
      end

      it 'expect to substract ConversMoney instance with a float' do
        expect(substract_instance_with_a_float).to have_attributes(:amount => 0, :currency =>'USD')
      end

      it 'expect to substract an ConversMoney amount attribute to be an integer' do
        expect(total_amount_attribute_class).to be(Fixnum)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)                 { ConversMoney.new(20, 'EUR') }
        let(:substract_operation_in_eur) { fifty_eur - twenty_eur }

        it 'expect to substract variables with the same currency' do
          expect(substract_operation_in_eur).to have_attributes(:amount => 30.0, :currency => 'EUR')
        end
      end
    end

    describe '#*' do
      let(:multiply_operation)                  { fifty_eur * twenty_usd }
      let(:multiply_instance_with_a_float)      { twenty_usd * 20.00 }
      let(:multiply_inverse_currency_operation) { fifty_eur * twenty_usd }
      let(:multiply_instance_with_an_integer)   { twenty_usd * 3 }
      let(:total_amount_attribute_class)        { multiply_instance_with_an_integer.amount.class }

      it 'expect to multiply ConversMoney instance with an integer' do
        expect(multiply_instance_with_an_integer).to have_attributes(:amount => 60, :currency => 'USD')
      end

      it 'expect to multiply none fixed rate variables inverting conversion rates' do
        expect(multiply_inverse_currency_operation).to have_attributes(:amount => 901.0, :currency => 'EUR')
      end

      it 'expect to multiply variables in different currencies' do
        expect(multiply_operation).to have_attributes(:amount => 901.0, :currency => 'EUR')
      end

      it 'expect to multiply operation of a ConversMoney class' do
        expect(multiply_operation).to be_an_instance_of(ConversMoney)
      end

      it 'expect to multiply an ConversMoney instance with a float' do
        expect(multiply_instance_with_a_float).to have_attributes(:amount => 400.0, :currency => 'USD')
      end

      it 'expect to multiply an ConversMoney amount attribute to be an integer' do
        expect(total_amount_attribute_class).to be(Fixnum)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)                { ConversMoney.new(20, 'EUR') }
        let(:multiply_operation_in_eur) { fifty_eur * twenty_eur }

        it 'expect to multiply variables with the same currency' do
          expect(multiply_operation_in_eur).to have_attributes(:amount => 1000.0, :currency => 'EUR')
        end
      end
    end

    describe '#/' do
      let(:divide_operation)                  { fifty_eur / twenty_usd }
      let(:divide_instance_with_a_float)      { twenty_usd / 20.00 }
      let(:divide_inverse_currency_operation) { fifty_eur / twenty_usd }
      let(:divide_instance_with_an_integer)   { fifty_eur / 2 }
      let(:total_amount_attribute_class)      { divide_instance_with_an_integer.amount.class }

      it 'expect to divide an inverse conversion rate ConverMoney instance with an integer and return an instance' do
        expect(divide_instance_with_an_integer).to have_attributes(:amount => 25, :currency => 'EUR')
      end

      it 'expect to divide none fixed rate variables inverting conversion rates' do
        expect(divide_inverse_currency_operation).to have_attributes(:amount => 2.77, :currency => 'EUR')
      end

      it 'expect to be divide_operation a ConversMoney class' do
        expect(divide_operation).to be_an_instance_of(ConversMoney)
      end

      it 'expect to divide an ConversMoney instance with a float' do
        expect(divide_instance_with_a_float).to have_attributes(:amount => 1.0, :currency => 'USD')
      end

      it 'expect to multiply an ConversMoney amount attribute to be an integer' do
        expect(total_amount_attribute_class).to be(Fixnum)
      end

      context 'when the currency is the same' do
        let(:twenty_eur)           { ConversMoney.new(20, 'EUR') }
        let(:add_operation_in_eur) { fifty_eur / twenty_eur }

        it 'expect to divide variables with the same currency' do
          expect(add_operation_in_eur).to have_attributes(:amount => 2.0, :currency => 'EUR')
        end
      end
    end

    describe '#==' do
      let(:fifty_eur_equal_twenty_usd)                { fifty_eur == twenty_usd }
      let(:fifty_five_point_five_usd)                 { described_class.new(55.50, 'USD') }
      let(:fifty_five_point_five_usd_equal_fifty_eur) { fifty_five_point_five_usd == fifty_eur }
      let(:compare_instance_with_a_float)             { twenty_usd == 20.00 }
      let(:dot_forty_nine_nine)                       { described_class.new(0.4999, 'EUR') }
      let(:dot_fourty_nine_eight_five)                { described_class.new(0.4985, 'EUR') }
      let(:rouded_amounts_are_equal_in_cents)         { dot_forty_nine_nine == dot_fourty_nine_eight_five }
      let(:compare_inverse_currency_operation)        { fifty_eur == fifty_five_point_five_usd }

      it 'expect none fixed rate variables to be equal inverting conversion rates' do
        expect(compare_inverse_currency_operation).to be(true)
      end

      it 'expect to not be equal' do
        expect(fifty_eur_equal_twenty_usd).to be(false)
      end

      it 'expect to be equal' do
        expect(fifty_five_point_five_usd_equal_fifty_eur).to be(true)
      end

      it 'expect to be equal ConversMoney instance with a float' do
        expect(compare_instance_with_a_float).to eql(true)
      end

      it 'expect to be rounded amounts equal' do
        expect(rouded_amounts_are_equal_in_cents).to eq(true)
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
      let(:inverse_currency_operation_to_be_greater) { fifty_eur > twenty_usd }
      let(:twenty_usd_to_be_greater)                 { twenty_usd > fifty_eur }
      let(:twenty_usd_to_be_greater_a_ten_as_float)  { twenty_usd > 10.00 }

      it 'expect none fixed rate variables to be greater than inverting conversion rates' do
        expect(inverse_currency_operation_to_be_greater).to be(true)
      end

      it 'expect twenty_usd not to be greater than fifty_eur' do
        expect(twenty_usd_to_be_greater).to be(false)
      end

      it 'expect twenty_usd to be greater than a float' do
        expect(twenty_usd_to_be_greater_a_ten_as_float).to eql(true)
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
      let(:inverse_currency_operation_to_be_smaller)      { fifty_eur < twenty_usd }
      let(:twenty_usd_to_be_smaller)                      { twenty_usd < fifty_eur }
      let(:twenty_usd_to_be_smaller_than_thirty_as_float) { twenty_usd < 30.00 }

      it 'expect fifty_eur as inverse currency, to be smaller than twenty_usd' do
        expect(inverse_currency_operation_to_be_smaller).to be(false)
      end

      it 'expect twenty_usd not to be smaller than fifty_eur' do
        expect(twenty_usd_to_be_smaller).to be(true)
      end

      it 'expect twenty_usd to be greater than a float' do
        expect(twenty_usd_to_be_smaller_than_thirty_as_float).to eql(true)
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
