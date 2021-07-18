class User < ActiveRecord::Base
  self.table_name = "users"
  has_many :credit_card_details,
    :primary_key => :id, :foreign_key => :user_id

  validates :name, :email, :pan_number, :aadhar_number, :bank_account_number, :ifsc_code, :monthly_income,:monthly_expense, presence: true
  validates :monthly_income,:monthly_expense, numericality: { only_integer: true }

  def self.save_user_details params
    user_row = User.find_or_create_by(
      :name => params['username'],
      :email => params['email'],
      :pan_number => params['pancard'],
      :aadhar_number => params['aadharcard'],
      :bank_account_number => params['bank_acnt_number'],
      :ifsc_code => params['ifsc_code'],
      :monthly_income => params['inflow'],
      :monthly_expense => params['outflow']
    )
    user_row
  end
end