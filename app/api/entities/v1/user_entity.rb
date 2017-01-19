module Entities
  module V1
    class UserEntity < Grape::Entity
      root 'user'
      expose :id, :auth_token
    end
  end
end