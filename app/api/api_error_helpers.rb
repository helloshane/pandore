module ApiErrorHelpers
  ERRORS = {
    grape_validate_error!: [20001, ''],
    authenticate_error!: [20002, '权限不足'],

    user_not_found: [30001, '用户不存在'],
    deal_not_found: [30002, '交易记录不存在'],

    illegal_deal_status: [40001, '交易记录初始化状态不正确'],
    illegal_voucher_status: [40002, '交易流水初始化状态不正确'],
    illegal_user_id: [40003, ''],
    illegal_deal_type: [40004, '交易类型不正确'],
    illegal_loan_deal_status: [40005, '借款交易状态未完成'],
    
    no_enough_money: [50001, '余额不足'],
    create_loan_deal_fail: [50002, '借款交易创建失败'],
    creatr_refund_deal_fail: [50003, '还款交易创建失败'],  
    confirm_deal_fail: [50004, '交易失败']
  }

  ERRORS.each do |error, _|
    define_method(error) do |*args|
      default = ERRORS.fetch(__method__)
      code = args.shift || default.shift
      msg = args.pop || default.pop
      error!({success: false, code: code, msg: msg}, 200)
    end
  end

end
