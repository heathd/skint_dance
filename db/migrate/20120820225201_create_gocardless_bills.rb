class CreateGocardlessBills < ActiveRecord::Migration
  def change
    create_table :gocardless_bills do |t|
      t.string :gocardless_id
      t.datetime :created_at
      t.string :description
      t.string :amount
      t.string :name
      t.string :status
      t.string :merchant_id
      t.string :source_type
      t.string :source_id
      t.string :user_id
      t.string :user_email
      t.string :user_first_name
      t.string :user_last_name
      t.integer :reservation_id
    end
  end
end
