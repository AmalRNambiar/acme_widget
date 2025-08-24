# Piktochart Fullstack Developer Coding Test (Ruby)
# Acme Widget Co Shopping Basket

A Ruby implementation of a shopping basket system for Acme Widget Co, featuring product catalog management, dynamic delivery pricing, and promotional offers.

## Overview

This system implements a flexible shopping basket that can:
- Add products by product code
- Apply promotional offers (currently supports "Buy One Get One Half Price")
- Calculate delivery charges based on order value
- Provide precise monetary calculations using BigDecimal

## Products

The system supports three widget types:

| Product Code | Name         | Price  |
|-------------|--------------|--------|
| R01         | Red Widget   | $32.95 |
| G01         | Green Widget | $24.95 |
| B01         | Blue Widget  | $7.95  |

## Delivery Rules

Delivery charges are calculated based on order subtotal (after discounts):

- **Under $50**: $4.95 delivery
- **$50 - $89.99**: $2.95 delivery  
- **$90 and above**: Free delivery

## Special Offers

### Buy One Get One Half Price (BOGO)
Currently implemented for Red Widgets (R01):
- When buying multiple red widgets, every second item is half price
- Discount applies to the cheaper item in each pair
- Odd numbers of items: the unpaired item pays full price

## Architecture

The system follows object-oriented design principles with clear separation of concerns:

```
lib/
├── product.rb              # Product model with validation
├── catalogue.rb            # Product catalog with lookup functionality
├── delivery_rules.rb       # Delivery charge calculation logic
├── offer.rb               # Abstract base class for offers
├── basket.rb              # Main basket implementation
└── offers/
    └── buy_one_get_one_half_price.rb  # BOGO offer implementation
```

### Key Classes

- **`Product`**: Represents a product with code, name, and price
- **`Catalogue`**: Manages product lookup with case-insensitive search
- **`DeliveryRules`**: Calculates delivery charges based on configurable thresholds
- **`Offer`**: Abstract base class for promotional offers
- **`BuyOneGetOneHalfPrice`**: Specific implementation of BOGO half-price offer
- **`Basket`**: Main class that orchestrates products, delivery, and offers

## Usage

### Basic Usage

```ruby
require_relative 'lib/basket'
require_relative 'lib/product'
require_relative 'lib/catalogue'
require_relative 'lib/delivery_rules'
require_relative 'lib/offers/buy_one_get_one_half_price'

# Set up products
products = [
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
]

# Create catalogue
catalogue = Catalogue.new(products)

# Set up delivery rules
delivery_rules = DeliveryRules.new([
  [50, 4.95],           # Under $50: $4.95
  [90, 2.95],           # $50-$89.99: $2.95  
  [Float::INFINITY, 0.0] # $90+: Free
])

# Create offers
offers = [BuyOneGetOneHalfPrice.new('R01')]

# Create basket
basket = Basket.new(
  catalogue: catalogue,
  delivery_rules: delivery_rules,
  offers: offers
)

# Add products
basket.add('B01')
basket.add('G01')

# Calculate total
puts basket.total # => 37.85
```

### Example Calculations

| Items | Subtotal | Discount | After Discount | Delivery | Total |
|-------|----------|----------|----------------|----------|-------|
| B01, G01 | $32.90 | $0.00 | $32.90 | $4.95 | **$37.85** |
| R01, R01 | $65.90 | $16.48 | $49.42 | $4.95 | **$54.37** |
| R01, G01 | $57.90 | $0.00 | $57.90 | $2.95 | **$60.85** |
| B01, B01, R01, R01, R01 | $114.75 | $16.48 | $98.27 | $0.00 | **$98.27** |

## Installation & Testing

### Prerequisites
- Ruby 2.7+ 
- Bundler

### Setup

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run tests with detailed output
bundle exec rspec -f documentation
```

### Project Structure

```
project_root/
├── lib/                 # Source code
│   ├── *.rb            # Core classes
│   └── offers/         # Offer implementations
├── spec/               # Test files
│   ├── spec_helper.rb
│   └── basket_spec.rb
├── Gemfile            # Dependencies
├── .rspec             # RSpec configuration
└── README.md          # This file
```

## Technical Details

### Precision & Accuracy
- Uses `BigDecimal` for all monetary calculations to avoid floating-point precision issues
- Proper rounding to 2 decimal places for final totals
- Input validation prevents invalid data from entering calculations

### Validation & Error Handling
- **Product validation**: Ensures valid codes, names, and positive prices
- **Catalogue validation**: Prevents duplicate product codes, validates product instances
- **Basket validation**: Checks for unknown product codes, validates dependencies
- **Offer validation**: Ensures proper item arrays and calculations

### Extensibility
- **Pluggable offers**: Easy to add new promotional offers by extending `Offer` class
- **Configurable delivery rules**: Supports any number of threshold-based delivery tiers
- **Flexible product catalog**: Can be extended with additional product attributes

## Design Decisions & Assumptions

### Assumptions Made
1. **BOGO Logic**: "Buy one get one half price" applies discount to the cheaper item in each pair
2. **Case Sensitivity**: Product codes are case-insensitive (R01 = r01)
3. **Delivery Calculation**: Based on subtotal after applying all discounts
4. **Multiple Offers**: All applicable offers stack (sum their discounts)
5. **Precision**: Business requires 2 decimal place precision for monetary values

### Design Patterns
- **Strategy Pattern**: Used for offers - different discount strategies implement common interface
- **Dependency Injection**: Basket accepts catalogue, rules, and offers as dependencies
- **Single Responsibility**: Each class has one clear purpose
- **Open/Closed Principle**: Easy to extend with new offers without modifying existing code

### Performance Considerations
- **Hash-based lookup**: O(1) product lookup in catalogue
- **Immutable objects**: Frozen strings and arrays prevent accidental mutations
- **Efficient calculations**: Minimize object creation in hot paths

## Future Enhancements

Potential improvements for production use:
- **Quantity-based operations**: Add/remove multiple items at once
- **Advanced offers**: Percentage discounts, buy X get Y free, category-based offers
- **Persistent storage**: Database integration for products and rules
- **Currency support**: Multi-currency pricing and display
- **Inventory tracking**: Stock levels and availability checks
- **User sessions**: Multiple baskets per user
- **Tax calculation**: Regional tax rules and calculations

## Contributing

1. Follow existing code style and patterns
2. Add tests for new functionality  
3. Ensure all tests pass
4. Update documentation for API changes

## License

This project is for demonstration purposes as part of the Acme Widget Co coding assessment.