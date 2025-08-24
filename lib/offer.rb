# frozen_string_literal: true

# Base interface for offers. Each offer must implement `apply`.
class Offer
  def apply(items)
    raise NotImplementedError, "#{self.class} must implement #apply(items)"
  end

  protected

  def validate_items!(items)
    raise ArgumentError, "Items must be an array" unless items.is_a?(Array)

    invalid_items = items.reject { |item| item.respond_to?(:price) && item.respond_to?(:code) }
    unless invalid_items.empty?
      raise ArgumentError, "All items must respond to #price and #code methods"
    end
  end
end
