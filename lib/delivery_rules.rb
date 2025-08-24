# frozen_string_literal: true

require "bigdecimal"

# Encapsulates delivery charge logic.
class DeliveryRules
  def initialize(rules = [])
    raise ArgumentError, "Rules must be an array" unless rules.is_a?(Array)
    raise ArgumentError, "At least one delivery rule must be provided" if rules.empty?

    @rules = build_rules(rules)
    validate_rules!
  end

  def charge_for(subtotal)
    raise ArgumentError, "Subtotal must be a non-negative number" unless
      subtotal.is_a?(Numeric) && subtotal >= 0

    rule = @rules.find { |threshold, _| BigDecimal(subtotal.to_s) < BigDecimal(threshold.to_s) }
    rule ? BigDecimal(rule.last.to_s) : BigDecimal("0")
  end

  private

  def build_rules(rules)
    rules.map do |rule|
      raise ArgumentError, "Each rule must have exactly 2 elements [threshold, charge]" unless rule.size == 2

      threshold, charge = rule
      raise ArgumentError, "Threshold must be a positive number or Float::INFINITY" unless
        threshold == Float::INFINITY || (threshold.is_a?(Numeric) && threshold.positive?)
      raise ArgumentError, "Charge must be a non-negative number" unless
        charge.is_a?(Numeric) && charge >= 0

      [threshold, charge]
    end.sort_by(&:first)
  end

  def validate_rules!
    has_infinity_threshold = @rules.any? { |threshold, _| threshold == Float::INFINITY }
    raise ArgumentError, "Rules must include a catch-all rule with Float::INFINITY threshold" unless has_infinity_threshold
  end
end
