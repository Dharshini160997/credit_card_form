module  ValidationHelper
  def self.validate params
    !params['username'].blank? && !params['email'].blank? && !params['pancard'].blank? && !params['aadharcard'].blank? && !params['bank_acnt_number'].blank? && !params['ifsc_code'].blank? && !params['inflow'].blank? && !params['outflow'].blank? && params['inflow'].to_i >= params['outflow'].to_i
  end 
end