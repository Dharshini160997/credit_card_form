class CreditCardController < ApplicationController
  infinity = Float::INFINITY
  def submit_details
    begin
      if ValidationHelper.validate params
        user_row = User.save_user_details params
        credit_limit = calculate_credit_limit params['inflow'].to_i,params['outflow'].to_i
        credibility_score = calculate_credibility_score params['email'],user_row
        CreditCardDetail.save_credit_details credit_limit,credibility_score,user_row
        render :success_page
      else
        raise "invalid params"
      end
    rescue => exception
      render :failure_page
    end
  end

  def calculate_credit_limit income,expense
    max_emi = calculate_max_emi income,expense
    term_in_months = TERM_IN_MONTHS[get_term max_emi]
    return (max_emi * term_in_months).to_i
  end

  def calculate_max_emi income,expense
    return ((income/2.0) - expense)
  end

  def get_term max_emi
    case max_emi
      when 0..5000  then "first"
      when 5001..10000  then "second"
      when 10001..20000 then "third"
      when 20001..infinity then "fourth"
    end
  end

  def calculate_credibility_score email,user_row
    full_contact_response = get_full_contact_response email
    credibility_score = 0
    credibility_score = credibility_score + 1 if has_linkedin_profile full_contact_response
    credibility_score = credibility_score + 1 if has_facebook_profile full_contact_response
    credibility_score = credibility_score + 1 if has_twitter_profile full_contact_response
    credibility_score = credibility_score + 1 if has_applied_loan user_row
    credibility_score
  end

  def get_full_contact_response email
    url = FULL_CONTACT_API + email
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request['authorization'] = "Bearer #{API_KEY}"
    request['Content-Type'] = 'application/json'
    response = http.request(request)
    MOCKED_RESPONSE
  end

  def has_linkedin_profile response
    check_for "linkedin",response
  end

  def has_facebook_profile response
    check_for "facebook",response
  end

  def has_twitter_profile response
    check_for "twitter",response
  end

  def check_for type,response
    response['socialProfiles'].each do |profile|
     if profile['type'] == type
      return true
     end
    end
    return false
  end

  def has_applied_loan user_row
    CreditCardDetail.exists?(user_id:user_row['id'])
  end

  def display_table
    table_data = CreditCardDetail.fetch_table_data
    render partial: "table_details" , locals: {table_data: table_data}
  end
end