class Order < ApplicationRecord
    belongs_to :item
    belongs_to :customer

    validates :price,
                        presence: true,
                        numericality: { greater_than: 0 }
    validates :quantity,
                        presence: true,
                        numericality: { greater_than_or_equal_to: 0 }
end
