require_relative "product"
require_relative "catalogue"
require_relative "delivery_rules"
require_relative "offer"

# Represents a shopping basket with products, delivery rules, and offers.
class Basket
  def initialize(catalogue:, delivery_rules:, offers: [])
    @catalogue = catalogue
    @delivery_rules = delivery_rules
    @offers = offers
    @items = []
  end

  # Add a product by its code.
  def add(product_code)
    product = @catalogue.find(product_code)
    raise ArgumentError, "Unknown product code: #{product_code}" unless product

    @items << product
  end

  # Calculate total including offers and delivery.
  def total
    subtotal = @items.sum(&:price)
    discount = @offers.sum { |offer| offer.apply(@items) }
    subtotal_after_discount = subtotal - discount
    delivery = @delivery_rules.charge_for(subtotal_after_discount)

    (subtotal_after_discount + delivery).round(2)
  end
end
