# GrapeSwaggerRails.options.url          = '/api/v1/doc'
GrapeSwaggerRails.options.app_url      = '/'
GrapeSwaggerRails.options.app_name     = 'Pandore Api'
GrapeSwaggerRails.options.api_key_name = 'token'
GrapeSwaggerRails.options.api_key_type = 'query'

GrapeSwaggerRails.options.before_filter do |request|
  authenticate_or_request_with_http_basic do |username, password|
    username == 'pandore' && password == 'hei2017'
  end

  GrapeSwaggerRails.options.url = "api/v1/doc" unless request.query_parameters['version']
end
