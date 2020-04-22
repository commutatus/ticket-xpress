require 'net/https'
require 'uri'
require 'nokogiri'

require 'ticket_xpress/configuration'
# require 'ticket_xpress/authentication'

module TicketXpress
  class << self
    attr_accessor :configuration
    require 'net/http'
    require 'uri'
    require 'json'

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end

    def get_voucher_detail(voucher)
      uri = URI.parse("#{config.base_url}/api/vouchers/ETX_001-#{voucher}")
      header = { 'Content-Type': 'application/json', 'X-Correlation-Id': DateTime.now.to_i.to_s, 'X-Client-Id': configuration.client_id, 'X-Client-Secret': configuration.client_secret }
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri, header)
      response = http.request(request)
      return JSON.parse(response.body)
    end

    def authorize_voucher(voucher, redeem_amount)
      request_body = {
        capture_mode: "manual",
        acceptance_point_ref: DateTime.now.to_i.to_s,
        currency: "INR",
        vouchers: [
          {
            ref: voucher,
            value: redeem_amount,
            product_class: "ETX_001"
          }
        ]
      }
      request_tx('/api/transactions', request_body)
    end

    def capture_voucher(voucher, redeem_amount, capture_url, invoice_id, invoice_amount, email, phone)
      request_body = {
      	acceptance_point_ref: DateTime.now.to_i.to_s,
      	vouchers: [ {
      		ref: voucher,
      		value: redeem_amount,
      		product_class: "ETX_001"
      	}],
      	invoice_details:{
      		ref: invoice_id,
      		amount: invoice_amount
      	},
      	customer_details: {
      		email_address: email,
      		phone_number: phone
      	}
      }
      request_tx(capture_url, request_body)
    end

    def refund_voucher(voucher, redeem_amount, refund_url)
      request_body = {
        acceptance_point_ref: DateTime.now.to_i.to_s,
        currency: "INR",
        vouchers: [{
          ref: voucher,
          value: redeem_amount,
          product_class: "ETX_001"
        }]
      }
      request_tx(refund_url, request_body)
    end

    def request_tx(path, request_body)
      uri = URI.parse("#{config.base_url}" + path)
      header = { 'Content-Type': 'application/json', 'X-Correlation-Id': DateTime.now.to_i.to_s, 'X-Client-Id': configuration.client_id, 'X-Client-Secret': configuration.client_secret }
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = request_body.to_json
      # Send the request
      response = http.request(request)
      return JSON.parse(response.body)
    end
  end
end
