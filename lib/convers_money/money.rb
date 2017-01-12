module ConversMoney
  class Money
    def initialize(amount, currency)
      raise 'Conversion rates not configured' unless ConversMoney.configured?
    end
  end
end