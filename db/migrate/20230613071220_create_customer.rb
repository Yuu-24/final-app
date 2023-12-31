class CreateCustomer < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string :password_digest
      t.string :phone_no
      t.timestamp :last_login

      t.timestamps
    end
  end
end
