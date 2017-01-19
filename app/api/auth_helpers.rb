module AuthHelpers
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
end
