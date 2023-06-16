class AddTokenToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :token, :integer
    add_column :orders, :token, :string
  end
end
