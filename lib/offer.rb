# Base interface for offers. Each offer must implement `apply`.
class Offer
  def apply(items)
    raise NotImplementedError, "Offers must implement #apply"
  end
end
