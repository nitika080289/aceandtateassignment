require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe 'POST /api/orders/route_order' do
    let(:valid_payload) do
      {
        id:  2020020001,
        shipping_country: "DE",
        lines: [ {
                       sku: "metal-frame-1",
                       quantity: 1,
                       prescription: {
                         type: "multifocal",
                         lens_color: nil,
                         left: {
                           SPH: -1
                         },
                         right: {
                           SPH: -1.25
                         }
                       }
                     } ]
      }
    end

    let(:unprocessable_payload) do
      {
        id:  2020020001,
        shipping_country: "DE",
        lines: [ {
                   quantity: 1,
                   prescription: {
                     type: "multifocal",
                     lens_color: nil,
                     left: {
                       SPH: -1
                     },
                     right: {
                       SPH: -1.25
                     }
                   }
                 } ]
      }
    end

    let(:bad_request_payload) do
      {
        id:  2020020001,
        shipping_country: "DE"
      }
    end

    let(:headers) do
      { "Content-Type" => "application/json" }
    end

    it 'returns status code 200 OK for a valid order payload' do
      post '/api/routeOrder', params: valid_payload.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "routing_result" => "ATLENS" })
    end

    it 'returns status code 422 unprocessable entity for an invalid order payload with sku blank' do
      post '/api/routeOrder', params: unprocessable_payload.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns status code 400 bad request for a malformed order payload' do
      post '/api/routeOrder', params: bad_request_payload.to_json, headers: headers

      expect(response).to have_http_status(:bad_request)
    end
  end
end
