class Customer < ApplicationRecord

    before_save { self.email = email.downcase}
    before_save { self.username = username.downcase}

    has_many :orders ,dependent: :destroy
    has_many :items , :through => :orders 

    validates :username, 
                        presence: true,
                        uniqueness: {case_sensitive: false},
                        length: {minimum: 3,maximum: 25}

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_PHONE_REGEX = /\A(\+91)?[7-9]\d{9}\z/

    validates :email,
                        presence: true,
                        length: {maximum: 105},
                        format: {with: VALID_EMAIL_REGEX}
    
    validates :phone_no,
                        presence: true,
                        format: {with: VALID_PHONE_REGEX}

    has_secure_password
end