class UpdateAdminToBoolean < ActiveRecord::Migration[6.0]
  def change
    remove_column :staffs, :is_admin, :integer
    add_column :staffs, :is_admin, :boolean, default: false
  end
end


