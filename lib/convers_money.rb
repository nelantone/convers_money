require 'convers_money/version'

# ConversMoney it's a Money Conversor given by fixed currency and change rates of your choice.
class ConversMoney
  attr_accessor :amount, :currency, :second_amount

  def initialize(amount, currency)
    @amount = amount
    @currency = currency.upcase
    ConversMoney.validate!
  end

  def self.conversion_rates(currency, conversion_rates)
    @conversion_rates ||= {}
    conversion_rates = Hash[conversion_rates.map { |k, v| [k.upcase, v] }]
    @conversion_rates.merge!(currency.upcase => conversion_rates)
  end

  def self.validate!
    raise 'not configured' unless @conversion_rates&.any?
  end

  def self.get_rate!(from_currency, to_currency)
    rates = @conversion_rates[from_currency]
    raise "no convention rates from #{from_currency}" unless rates
    rate = rates[to_currency]
    raise "no conversion rates to #{to_currency}" unless rate
    rate
  end

  def self.convert!(amount, from_currency, to_currency)
    get_rate!(from_currency, to_currency) * amount
  end

  def convert_to(currency)
    if self.currency.eql?(currency)
      self
    else
      converted_amount = ConversMoney.convert!(@amount, @currency, currency)
      amount_str = format('%.2f', converted_amount)
      ConversMoney.new(amount_str.to_f, currency)
    end
  end

  def inspect
    "#{format('%.2f', @amount)} #{@currency}"
  end

  def +(other)
    total_amount = amount + other.convert_to(currency).amount
    ConversMoney.new(format('%.2f', total_amount), currency)
  end

  def -(other)
    total_amount = amount - other.convert_to(currency).amount
    ConversMoney.new(format('%.2f', total_amount), currency)
  end

  def *(other)
    total_amount = amount * other.convert_to(currency).amount
    ConversMoney.new(format('%.2f', total_amount), currency)
  end

  def /(other)
    total_amount = amount / other.convert_to(currency).amount
    ConversMoney.new(format('%.2f', total_amount), currency)
  end

  def ==(other)
    amount == other.convert_to(currency).amount
  end

  def >(other)
    amount > other.convert_to(currency).amount
  end

  def <(other)
    amount < other.convert_to(currency).amount
  end

  def self.checking_fixed_currency(other, currency)
    if other.currency.eql?(currency)
      other
    else
      conversion_rates_access
      other.convert_to(currency)
    end
  end

  def self.conversion_rates_access
    @conversion_rates
  end

  private_class_method :conversion_rates_access
end
