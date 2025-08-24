# frozen_string_literal: true

# A simple catalogue that holds products and allows lookup by code.
class Catalogue
  def initialize(products = [])
    raise ArgumentError, "Products must be an array" unless products.is_a?(Array)

    products.each { |product| validate_product!(product) }
    check_duplicate_codes!(products)

    @products = products.each_with_object({}) do |product, hash|
      hash[normalize_code(product.code)] = product
    end
  end

  def find(code)
    return nil if code.nil? || code.to_s.strip.empty?

    @products[normalize_code(code)]
  end

  private

  def validate_product!(product)
    raise ArgumentError, "All items must be Product instances" unless product.is_a?(Product)
  end

  def check_duplicate_codes!(products)
    codes = products.map { |p| normalize_code(p.code) }
    duplicates = codes.select { |code| codes.count(code) > 1 }.uniq

    raise ArgumentError, "Duplicate product codes found: #{duplicates.join(", ")}" unless duplicates.empty?
  end

  def normalize_code(code)
    code.to_s.upcase.strip
  end
end
