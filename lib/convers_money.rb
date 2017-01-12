require "convers_money/version"
require 'convers_money/money'

module ConversMoney

  def self.get_rate!(from_currency, to_currency)
    rates = @conversion_rates[from_currency]
    raise "no converion rates from #{from_currency}" unless rates
    rate = rates[to_currency]
    raise "no conversion rates to #{to_currency}" unless rate
    rate
  end

  def self.convert!(amount, from_currency, to_currency)
    get_rate!(from_currency, to_currency) * amount
  end

  def self.validate!
    raise 'not configured' unless @conversion_rates&.any?
  end

  def self.conversion_rates(currency, conversion_rates)
    @conversion_rates ||= {}
    #conversion_rates = conversion_rates.keys.map(&:upcase) # Frozen variable error!
    conversion_rates = Hash[ conversion_rates.map{|k,v| [k.upcase, v] } ]
    @conversion_rates.merge!(currency.upcase => conversion_rates)
    #merge(!) bang missing!
  end
end

