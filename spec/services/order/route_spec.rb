require 'rails_helper'

RSpec.describe Order::Route do
  let(:stock) do
      {
        "ATLENS" => {
          "rimless-1" => 20,
          "metal-frame-1" => 200,
          "metal-frame-2" => 0
        },
        "LETHA" => {
          "metal-frame-2" => 200,
          "acetate-frame-1" => 100
        }
      }
  end

  def create_order(overrides = {})
    {
      "id" => 2020020001,
      "shipping_country" => "DE",
      "lines" => [ {
                     "sku" => "metal-frame-1",
                     "quantity" => 1,
                     "prescription" => {
                       "type" => "multifocal",
                       "lens_color" => nil,
                       "left" => {
                         "SPH" => -1
                       },
                       "right" => {
                         "SPH" => -1.25
                       }
                     }
                   } ]
    }.deep_merge(overrides)
  end
  it 'routes to ATLENS if prescription type is multifocal' do
    routing_result = described_class.new(create_order, stock).call
    expect(routing_result).to eq "ATLENS"
  end

  it 'routes to LETHA if sku is rimless' do
    order = create_order("lines" => [ { "sku" => "rimless-1" } ])
    routing_result = described_class.new(order, stock).call
    expect(routing_result).to eq "LETHA"
  end

  it 'routes to ATLENS if order is us bound' do
    order = create_order("shipping_country" => "US")
    routing_result = described_class.new(order, stock).call
    expect(routing_result).to eq "ATLENS"
  end

  it 'routes to ATLENS if the lens color is ATGRDRED01' do
    order = create_order("prescription" => { "lens_color" => "ATGRDRED01" })
    routing_result = described_class.new(order, stock).call
    expect(routing_result).to eq "ATLENS"
  end

  it 'routes to LETHA if ATLENS is out of stock' do
    order = create_order("lines" => [ { "sku" => "metal-frame-2" } ])
    routing_result = described_class.new(order, stock).call
    expect(routing_result).to eq "LETHA"
  end

  it 'routes to LETHA if the lens is high prescription' do
    order = create_order(
      "lines" => [ {
                    "sku" => "acetate-frame-1",
                    "prescription" => {
                      "left" => { "SPH" => -7 },
                      "right" => { "SPH" => -1.25 }
                    }
                  } ]
    )
    routing_result = described_class.new(order, stock).call
    expect(routing_result).to eq "LETHA"
  end
end
