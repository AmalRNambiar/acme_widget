# Encapsulates delivery charge logic.
class DeliveryRules
  def initialize(rules)
    # rules is expected to be an array of [threshold, charge]
    # Example: [[50, 4.95], [90, 2.95], [Float::INFINITY, 0.0]]
    @rules = rules.sort_by(&:first)
  end

  def charge_for(subtotal)
    rule = @rules.find { |threshold, _| subtotal < threshold }
    rule ? rule.last : 0.0
  end
end
