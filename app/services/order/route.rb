module Order
  class Route
  def initialize(order, stock)
    @order = order
    @stock = stock
  end
  def call
    return "LETHA" if rimless? || out_of_stock? || high_prescription?

    return "ATLENS" if multifocal? || us_bound? || atgrdred01?

    "ATLENS"
  end

  private

  def multifocal?
    @order.dig("prescription", "type") == "multifocal"
  end

  def rimless?
    @order["lines"][0]["sku"] == "rimless-1"
  end

  def us_bound?
    @order["shipping_country"]&.upcase == "US"
  end

  def atgrdred01?
    @order.dig("prescription", "lens_color")&.upcase == "ATGRDRED01"
  end

  def out_of_stock?
    sku = @order["lines"][0]["sku"]
    (@stock["ATLENS"].include?(sku) && @stock["ATLENS"][sku] == 0) || !@stock["ATLENS"].include?(sku)
  end

  def high_prescription?
    sph_left = @order.dig("prescription", "left", "SPH").to_i
    sph_right = @order.dig("prescription", "right", "SPH").to_i

    (sph_left < -6 || sph_left > 4) || (sph_right < -6 || sph_right > 4)
  end
  end
end
