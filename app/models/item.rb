class Item < ApplicationRecord

    has_many :orders
    has_many :customers , :through => :orders 

    validates :name, 
                        presence: true,
                        uniqueness: {case_sensitive: false}
    validates :price,
                        presence: true,
                        numericality: { greater_than: 0 }
    validates :quantity,
                        presence: true,
                        numericality: { greater_than_or_equal_to: 0 }
    
end