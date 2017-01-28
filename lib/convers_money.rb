require 'convers_money/version'
require 'pry'

# Money converter for given
class ConversMoney
  attr_accessor :amount, :currency, :second_amount

  def initialize(amount, currency)
    @amount = amount
    @currency = currency.upcase
    @second_amount = second_amount
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
    new_amount = ConversMoney.convert!(@amount, @currency, currency)
    new_amount_str = format('%.2f', new_amount)
    new_amount_str.to_f
  end

  def inspect
    "#{format('%.2f', @amount)} #{@currency}"
  end

  def +(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    total_amount = fixed_item.amount + other_base_converted_amount
    "#{format('%.2f', total_amount)} #{currency}"
  end

  def -(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    total_amount = fixed_item.amount - other_base_converted_amount
    "#{format('%.2f', total_amount)} #{currency}"
  end

  def *(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    total_amount = fixed_item.amount * other_base_converted_amount
    "#{format('%.2f', total_amount)} #{currency}"
  end

  def /(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    total_amount = fixed_item.amount / other_base_converted_amount
    "#{format('%.2f', total_amount)} #{currency}"
  end

  def ==(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    fixed_item.amount == other_base_converted_amount
  end

  def >(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    fixed_item.amount > other_base_converted_amount
  end

  def <(other)
    fixed_item = self
    other_base_converted_amount = ConversMoney.quantity_convertor(other, currency)
    fixed_item.amount < other_base_converted_amount
  end

  def self.conversion_rates_access
    @conversion_rates
  end

  def self.quantity_convertor(other, currency)
    if other.currency.equal?(currency)
      amount_and_currency.amount
    else
      @conversion_rates = ConversMoney.conversion_rates_access
      other.convert_to(currency)
    end
  end

  private_class_method :quantity_convertor, :conversion_rates_access
end
