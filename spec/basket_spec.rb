# frozen_string_literal: true

require "spec_helper"
require_relative "../lib/product"
require_relative "../lib/catalogue"
require_relative "../lib/delivery_rules"
require_relative "../lib/basket"
require_relative "../lib/offers/buy_one_get_one_half_price"

RSpec.describe Basket do
  let(:catalogue) do
    Catalogue.new([
      Product.new(code: "R01", name: "Red Widget", price: 32.95),
      Product.new(code: "G01", name: "Green Widget", price: 24.95),
      Product.new(code: "B01", name: "Blue Widget", price: 7.95),
    ])
  end

  let(:delivery_rules) do
    DeliveryRules.new([
      [50, 4.95],
      [90, 2.95],
      [Float::INFINITY, 0.0],
    ])
  end

  let(:offers) { [BuyOneGetOneHalfPrice.new("R01")] }
  let(:basket) { Basket.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers) }

  describe "original test cases" do
    it "calculates total for B01, G01" do
      basket.add("B01")
      basket.add("G01")
      expect(basket.total).to eq(37.85)
    end

    it "calculates total for R01, R01" do
      2.times { basket.add("R01") }
      expect(basket.total).to eq(54.38)
    end

    it "calculates total for R01, G01" do
      basket.add("R01")
      basket.add("G01")
      expect(basket.total).to eq(60.85)
    end

    it "calculates total for B01, B01, R01, R01, R01" do
      basket.add("B01")
      basket.add("B01")
      basket.add("R01")
      basket.add("R01")
      basket.add("R01")
      expect(basket.total).to eq(98.28)
    end
  end

  describe "error handling" do
    it "raises error for unknown product code" do
      expect { basket.add("UNKNOWN") }.to raise_error(ArgumentError, /Unknown product/)
    end

    it "handles empty basket" do
      expect(basket.total).to eq(4.95)
    end
  end
end
