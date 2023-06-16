class AddTokenToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :token, :integer
  end
end
