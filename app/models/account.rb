class Account < ApplicationRecord
  has_one :user

  after_create :set_pandore_id

  enum account_type: {
    platform: 0,
    common: 1
  }

  private
  def set_pandore_id
    update(pandore_id: pandore_id_prefix + pandore_id_suffix)
  end

  def pandore_id_prefix
    return platform_prefix if platform?
    return common_prefix if common?
  end

  def platform_prefix
    '00'
  end

  def common_prefix
    '01'
  end

  def pandore_id_suffix
    ScatterSwap.hash(id)
  end
end
