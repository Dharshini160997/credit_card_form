class CreditCardDetail < ActiveRecord::Base
  self.table_name = "credit_card_details"
  belongs_to :user,
    :primary_key => :id, :foreign_key => :user_id

  validates :credit_limit,:credibility_score,:user_id, presence: true
  validates :credit_limit,:credibility_score, numericality: { only_integer: true }


  def self.save_credit_details credit_limit,credibility_score,user_row
    CreditCardDetail.find_or_create_by(
      credit_limit:credit_limit,
      credibility_score:credibility_score,
      user_id:user_row['id']
    )
  end

  def self.fetch_table_data
    self.joins(:user).select("email,credit_limit,credibility_score").group("users.id")
  end
end