class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :pan_number, null: false, unique: true
      t.string :aadhar_number, null: false, unique: true
      t.integer :bank_account_number, null: false, unique: true
      t.string :ifsc_code, null: false
      t.integer :monthly_income,null: false
      t.integer :monthly_expense,null: false
      t.timestamps
    end
  end
end
