require_relative "../offer"

# Special offer: buy one red widget, get the second half price.
class BuyOneGetOneHalfPrice < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items)
    target_items = items.select { |item| item.code == @product_code }
    return 0 if target_items.empty?

    prices = target_items.map(&:price).sort.reverse

    # Every second item is half price
    discount = 0.0
    prices.each_slice(2) do |first, second|
      discount += (second * 0.5) if second
    end

    discount
  end
end
