# A simple catalogue that holds products and allows lookup by code.
class Catalogue
  def initialize(products)
    @products = products.index_by(&:code)
  end

  def find(code)
    @products[code]
  end
end
