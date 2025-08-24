# frozen_string_literal: true

require "bigdecimal"

class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    raise ArgumentError, "Product code cannot be nil or empty" if code.nil? || code.to_s.strip.empty?
    raise ArgumentError, "Product name cannot be nil or empty" if name.nil? || name.to_s.strip.empty?
    raise ArgumentError, "Price must be a positive number" unless valid_price?(price)

    @code = code.to_s.strip.freeze
    @name = name.to_s.strip.freeze
    @price = BigDecimal(price.to_s)
  end

  private

  def valid_price?(price)
    return false if price.nil?

    numeric_price = BigDecimal(price.to_s)
    numeric_price.positive?
  rescue ArgumentError, TypeError
    false
  end
end
