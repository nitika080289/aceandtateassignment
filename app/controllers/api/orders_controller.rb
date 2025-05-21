module Api
  class OrdersController < ApplicationController
    def route_order
      order_params = params.permit(:id, :shipping_country,
                                   lines: [
                                     :sku, :quantity,
                                     prescription: [
                                       :type, :lens_color,
                                      { left: [ :SPH ], right: [ :SPH ] }
                                      ]
                                   ])
      if !order_params["lines"].present? || !order_params["id"].present? || !order_params["shipping_country"].present?
        return render json: { message: "Missing required parameters" }, status: :bad_request
      end
      validator = OrderPayloadValidator.new(order_params)

      unless validator.valid?
        render json: { message: validator.errors.full_messages.to_sentence }, status: :unprocessable_entity
        return
      end

      routing_result = Order::Route.new(order_params, STOCK_OVERVIEW).call

      render json: { routing_result: routing_result }, status: :ok

    rescue JSON::ParserError => e
      render json: { message: e.message }, status: :bad_request
    rescue => e
      Rails.logger.error e.message
      render json: { message: e.message }, status: :internal_server_error
    end
  end
end
