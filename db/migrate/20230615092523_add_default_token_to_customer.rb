class AddDefaultTokenToCustomer < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers, :token, :integer
    add_column :customers, :token, :integer, default: 0
  end
end

