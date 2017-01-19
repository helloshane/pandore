module Entities
  module V1
    class VoucherListEntity < Grape::Entity
      present_collection true
      expose :items, using: VoucherEntity
    end
  end
end