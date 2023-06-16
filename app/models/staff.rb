class Staff < ApplicationRecord
    before_save { self.email = email.downcase}
    before_save { self.username = username.downcase}

    has_many :items 

    validates :username, 
                        presence: true,
                        uniqueness: {case_sensitive: false},
                        length: {minimum: 3,maximum: 25}

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_PHONE_REGEX = /\A(\+91)?[7-9]\d{9}\z/
    # VALID_AADHAAR_REGEX = /^\d{4}(?:\s?\d{4}){2}$/
    VALID_PAN_REGEX = /[A-Z]{5}[0-9]{4}[A-Z]{1}/

    validates :email,
                        presence: true,
                        length: {maximum: 105},
                        format: {with: VALID_EMAIL_REGEX}
    
    validates :phone_no,
                        presence: true,
                        format: {with: VALID_PHONE_REGEX}
    
    # validates :aadhaar_no,
    #                     presence: true
                        # format: {with: VALID_AADHAAR_REGEX}
    
    # validates :pan_no,
    #                     presence: true,
    #                     format: {with: VALID_PAN_REGEX}

    has_secure_password
end