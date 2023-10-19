class User < ApplicationRecord
    has_secure_password
  
    validates :user_name, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }

    has_many :reservations, dependent: :type
    has_many :rooms, through: :reservations
  
end
