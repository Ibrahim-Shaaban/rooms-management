class Room < ApplicationRecord

    enum room_type: { single: 0, double: 1, suite: 2 }, _default: :ongoing

    validates :number, presence: true, uniqueness: true
    validates :room_type, presence: true
    validates :price_per_night, presence: true

    has_many :reservations, dependent: :destroy
    has_many :users, through: :reservations

    def self.log(message=nil)
        @my_log ||= Logger.new("#{Rails.root}/log/add_room.log")
        @my_log.debug(message) unless message.nil?
    end
end
