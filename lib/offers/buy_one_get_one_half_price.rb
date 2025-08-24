# frozen_string_literal: true

require_relative "../offer"
require "bigdecimal"

# Special offer: buy one red widget, get the second half price.
class BuyOneGetOneHalfPrice < Offer
  attr_reader :product_code

  def initialize(product_code)
    raise ArgumentError, "Product code cannot be nil or empty" if product_code.nil? || product_code.to_s.strip.empty?
    @product_code = product_code.to_s.upcase.strip.freeze
  end

  def apply(items)
    validate_items!(items)

    target_items = items.select { |item| normalize_code(item.code) == @product_code }
    return BigDecimal("0") if target_items.size < 2

    calculate_discount(target_items)
  end

  private

  def normalize_code(code)
    code.to_s.upcase.strip
  end

  def calculate_discount(target_items)
    prices = target_items.map { |item| BigDecimal(item.price.to_s) }.sort.reverse

    total_discount = BigDecimal("0")

    prices.each_slice(2) do |full_price, discounted_price|
      next unless discounted_price

      discount_amount = discounted_price * BigDecimal("0.5")
      total_discount += discount_amount
    end

    total_discount
  end
end
