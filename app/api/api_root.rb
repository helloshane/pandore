class ApiRoot < Grape::API
  content_type :json, "application/json;charset=UTF-8"
  format :json

  # 这里是为了更好的演示
  def self.custom_auth_headers?
    true
  end

  def self.auth_headers
    return {} unless custom_auth_headers?

    { 'Authorization' => { description: "api请求token", required: false, values: [User.first.try(:auth_token)] } }
  end

  helpers ApiErrorHelpers
  helpers AuthHelpers

  helpers do
    def present_ok(source, options)
      present :success, true
      present :code, 10000
      present :msg, 'ok'
      present(:data, source, options)
    end

    def raise_error(error)
      method(error).call
    end
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    grape_validate_error!(nil, e.message)
  end

  mount V1::Root
end

