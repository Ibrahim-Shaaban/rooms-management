class Room < ApplicationRecord

    enum room_type: { single: 0, double: 1, suite: 2 }, _default: :ongoing

    validates :number, presence: true, uniqueness: true
    validates :room_type, presence: true
    validates :price_per_night, presence: true
end
