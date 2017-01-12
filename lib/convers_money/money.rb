require 'pry'

module ConversMoney
  class Money
    # include ConversMoney
    #not sure about this one up
    attr_accessor :amount, :currency

    def initialize(amount, currency)
      @amount = amount
      @currency = currency.upcase
      #undefined method `validate' for ConversMoney:Module
      ConversMoney.validate!
    end

    def convert_to(currency)
      ConversMoney.convert!(@amount, @currency, currency.upcase)
    end

  end
end
