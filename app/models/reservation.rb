class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :start_date, presence: true
  validates :end_date, presence: true

  def self.log(message=nil)
    @my_log ||= Logger.new("#{Rails.root}/log/make_reservation.log")
    @my_log.debug(message) unless message.nil?
end
end
