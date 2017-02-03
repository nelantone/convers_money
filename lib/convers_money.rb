require 'convers_money/version'
require 'pry'

# ConversMoney it's a Money Conversor given by fixed currency and change rates of your choice.
class ConversMoney
  include Comparable
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency.upcase
    ConversMoney.validate!
  end

  def self.conversion_rates(currency, conversion_rates)
    @conversion_rates ||= {}
    conversion_rates = Hash[conversion_rates.map { |fixed_currency, rates| [fixed_currency.upcase, rates] }]
    @conversion_rates.merge!(currency.upcase => conversion_rates)
    unless @conversion_rates.nil? || conversion_rates.nil?
      @conversion_rates.each do |fixed_currency, rates|
        rates.map do |currency_rate, value|
          inverse_conversion = { fixed_currency => format('%.5f', (1 / value)).to_f.round(5) }
          @conversion_rates = @conversion_rates.merge( currency_rate => inverse_conversion ) unless currency.eql? currency_rate
        end
      end
    end
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
      ConversMoney.new(amount_str.to_f.round(2), currency)
    end
  end

  def inspect
    "#{format('%.2f', @amount)} #{@currency}"
  end

  def convert_float_to_instance(other, currency)
    if other.is_a? Float
      other = ConversMoney.new( other, currency)
    end
  end

  def +(other)
    if other.is_a? Float
      other = ConversMoney.new( other, currency)
    end
    total_amount = amount + other.convert_to(currency).amount
    ConversMoney.new(total_amount.to_f.round(2), currency)
  end

  def -(other)
    if other.is_a? Float
      other = ConversMoney.new( other, currency)
    end
    total_amount = amount - other.convert_to(currency).amount
    ConversMoney.new(total_amount.to_f.round(2), currency)
  end

  def *(other)
    if other.is_a? Float
      other = ConversMoney.new( other, currency)
    end
    total_amount = amount * other.convert_to(currency).amount
    ConversMoney.new(total_amount.to_f.round(2), currency)
  end

  def /(other)
    if other.is_a? Float
      other = ConversMoney.new( other, currency)
    end
    total_amount = amount / other.convert_to(currency).amount
    ConversMoney.new(total_amount.to_f.round(2), currency)
  end

  def <=>(other)
    if other.is_a? Float
      other = ConversMoney.new( other.round(2), currency)
    end
    amount.round(2) <=> other.convert_to(currency).amount.round(2)
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
