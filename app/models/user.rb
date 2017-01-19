class User < ApplicationRecord
  belongs_to :account

  after_create :set_auth_token

  def money
    account.amount.to_f
  end

  private
  def set_auth_token
    salt = Rails.application.secrets.user_token_key
    token = OpenSSL::HMAC.hexdigest('sha1', salt, id.to_s)
    update(auth_token: token)
  end 

end
