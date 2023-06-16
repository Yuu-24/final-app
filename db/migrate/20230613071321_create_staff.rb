class CreateStaff < ActiveRecord::Migration[6.0]
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string :password_digest
      t.string :phone_no
      t.timestamp :last_login
      t.string :address
      t.integer :is_admin
      t.string :aadhaar_no
      t.string :pan_no
      t.boolean :active, default: true
      t.string :designation
      t.decimal :salary, precision: 10, scale: 2
      
      t.timestamps
    end
  end
end
