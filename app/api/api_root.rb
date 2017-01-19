class ApiRoot < Grape::API
  content_type :json, "application/json;charset=UTF-8"
  format :json

  # 这个一般在接口联调时才进行放开
  def self.custom_auth_headers?
    true
  end

  def self.auth_headers
    return {} unless custom_auth_headers?

    # 接口安全考虑, token应该动态，用完即弃用
    # 这里是为了更好的演示
    { 'Authorization' => { description: "api请求token", required: false, values: [User.first.try(:auth_token)] } }
  end

  helpers ApiErrorHelpers
  helpers do
    def authenticate!
      allow_skip = skip_auth_paths.any? { |path| Regexp.new(path).match(request.path) }

      unless allow_skip
        token = request.headers['Authorization']
        auth = !!(token && User.find_by_auth_token(token))

        authenticate_error! unless auth
      end
    end

    def skip_auth_paths
      ['users/register']
    end

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

