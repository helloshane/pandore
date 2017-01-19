module Requests
  module JsonHelpers
    def json(symbolize_keys_value=true)
      @json = MultiJson.load(response.body, symbolize_keys: symbolize_keys_value)
    end
  end
end
