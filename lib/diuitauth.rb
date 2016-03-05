require "diuitauth/version"
require 'rest-client'
require 'jwt'

module Diuitauth
  # Your code goes here...
  class Login
    def self.get_session_token(client)
      begin
        JSON.parse(client)
      rescue JSON::ParserError => e
        return "Invalid JSON format"
      end

      params = [
        "app_id",
        "app_key",
        "key_id",
        "private_key",
        "exp",
        "platform",
        "user_serial",
        "device_id"
      ]

      # check json data is enough or not
      params.each do |p|
        unless (JSON.parse(client)).has_key?(p)
          return "can not find #{p}"
        end
      end

      clientJSON = JSON.parse(client)
      app_id = clientJSON["app_id"]
      app_key = clientJSON["app_key"]
      kid = clientJSON["key_id"]
      private_key = clientJSON["private_key"]
      exp = clientJSON["exp"].to_i
      platform = clientJSON["platform"]
      sub = clientJSON["user_serial"]
      device_id = clientJSON["device_id"]

      header = {
        'x-diuit-application-id' => app_id,
        'x-diuit-app-key' => app_key
      }
      res = RestClient.get('https://api.diuit.net/1/auth/nonce', header)
      nonce = (JSON.parse(res))["nonce"]
      jwt_header = {
        "typ" => 'JWT',
        "alg" => 'RS256',
        "cty" => "diuit-auth;v=1",
        "kid" => kid
      }

      jwt_payload = {
        "exp" => Time.at(exp).utc.iso8601,
        "iss" => app_id,
        "iat" => Time.now.utc.iso8601,
        "sub" => sub,
        "nonce" => nonce
      }

      token = JWT.encode jwt_payload, private_key, 'none', jwt_header

      request_data = {
        'jwt' => token,
        'deviceId' => device_id,
        'platform' => platform
      }
      request_headers = {
        'x-diuit-application-id' => app_id,
        'x-diuit-app-key' => app_key,
        'Content-Type' => 'application/json'
      }
      
      return RestClient.post 'https://api.diuit.net/1/auth/login', request_data, request_headers
    end

    def self.Test
      puts "Test"
    end
  end
end
