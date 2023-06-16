class CreateOrder < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :item_id
      t.integer :status, default: 1
      t.string :review_title
      t.text :review_descr
      t.boolean :voted, default: false

      t.timestamps
    end
  end
end
