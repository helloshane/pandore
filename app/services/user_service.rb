class UserService
  include ServiceResponse

  def register(params)
    tran_result = User.transaction do
      account = Account.create!(amount: params.amount, account_type: 'common')
      user = account.create_user!
    end
    return service_error(:creatr_user_fail) unless tran_result
    service_success(tran_result)
  end

end
