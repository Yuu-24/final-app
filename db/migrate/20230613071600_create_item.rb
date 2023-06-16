class CreateItem < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2
      t.integer :staff_id
      t.integer :upvotes
      t.integer :downvotes

      t.timestamps
    end
  end
end
