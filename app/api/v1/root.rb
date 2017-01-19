module V1
  class Root < Grape::API
    version 'v1'
    prefix :api

    mount V1::Users
    mount V1::Deals

    add_swagger_documentation({
      api_version: 'v1', 
      mount_path: 'doc', 
      hide_format: true, 
      hide_documentation_path: true
    })
  end
end
