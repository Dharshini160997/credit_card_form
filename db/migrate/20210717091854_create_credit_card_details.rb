class CreateCreditCardDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_card_details do |t|
      t.integer :credit_limit, null: false
      t.integer :credibility_score, null: false
      t.integer :user_id,null:false
      t.timestamps
    end
  end
end
