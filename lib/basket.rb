# frozen_string_literal: true

require "bigdecimal"
require_relative "product"
require_relative "catalogue"
require_relative "delivery_rules"
require_relative "offer"

# Represents a shopping basket with products, delivery rules, and offers.
class Basket
  def initialize(catalogue:, delivery_rules:, offers: [])
    validate_dependencies!(catalogue, delivery_rules, offers)

    @catalogue = catalogue
    @delivery_rules = delivery_rules
    @offers = offers.dup.freeze
    @items = []
  end

  def add(product_code)
    raise ArgumentError, "Product code cannot be nil or empty" if product_code.nil? || product_code.to_s.strip.empty?

    product = @catalogue.find(product_code)
    raise ArgumentError, "Unknown product code: #{product_code}" unless product

    @items << product
  end

  def total
    subtotal = calculate_subtotal
    discount = calculate_total_discount
    subtotal_after_discount = [subtotal - discount, BigDecimal("0")].max
    delivery = @delivery_rules.charge_for(subtotal_after_discount)

    total_amount = (subtotal_after_discount + delivery).round(2).to_f
  end

  private

  def validate_dependencies!(catalogue, delivery_rules, offers)
    raise ArgumentError, "Catalogue must respond to #find" unless catalogue.respond_to?(:find)
    raise ArgumentError, "Delivery rules must respond to #charge_for" unless delivery_rules.respond_to?(:charge_for)
    raise ArgumentError, "Offers must be an array" unless offers.is_a?(Array)

    offers.each_with_index do |offer, index|
      unless offer.respond_to?(:apply)
        raise ArgumentError, "Offer at index #{index} must respond to #apply"
      end
    end
  end

  def calculate_subtotal
    @items.sum { |item| BigDecimal(item.price.to_s) }
  end

  def calculate_total_discount
    @offers.sum { |offer| BigDecimal(offer.apply(@items).to_s) }
  end
end
