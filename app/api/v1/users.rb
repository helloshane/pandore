module V1
  class Users < Grape::API
    resources :users do
      before do
        authenticate!

        if params.user_id
          @user = User.find_by_id(params.user_id)
          raise_error(:user_not_found) if @user.nil?
        end

      end

      desc '用户注册' do
        detail '用户可根据返回id进行借款/还款操作, 使用返回token进行校验'
      end
      params do
        requires :amount, type: BigDecimal, values: { value: BigDecimal(0)..BigDecimal('Infinity') }, desc: '初始金额'
      end
      post :register do
        result = UserService.new.register(params)
        if result.success?
          present_ok(result.data, with: Entities::V1::UserEntity)
        else
          raise_error(result.error_id)
        end
      end

      route_param :user_id do
        desc '账户情况查询, 获取特定用户的余额、借出总额和借入总额情况', { headers: ApiRoot.auth_headers }
        get :account_detail do
          present_ok(@user, with: Entities::V1::AccountDetailEntity)
        end
      end

      desc '债务情况查询, 获取特定两个用户当前的借入借出总额情况', { headers: ApiRoot.auth_headers }
      params do
        requires :user_ids, type: String, desc: '两个待查询用户id,使用英文逗号分隔'
      end
      get :debt_detail do
        user_ids = params.user_ids.split(/,\s*/)
        return raise_error(:illegal_parameters) unless user_ids.size == 2

        users = User.where(id: user_ids)
        return raise_error(:user_not_all_found) unless users.size == user_ids.size

        user_array = [users.last.id, users.first, users.first.id, users.last]

        present_ok(Hash[*user_array], with: Entities::V1::DebtDetailEntity)
      end
    end # resource
  end
end