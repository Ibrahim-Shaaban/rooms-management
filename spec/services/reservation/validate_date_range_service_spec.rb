require 'rails_helper'

describe Reservation::ValidateDateRangeService do
  describe '#call' do
  current_date = Date.current

    context 'with valid date range' do
      it 'does not raise any exceptions' do
        start_date = current_date + 1.day
        end_date = current_date + 6.days

        service = Reservation::ValidateDateRangeService.new(
          start_date: start_date.to_s,
          end_date: end_date.to_s
        )

        expect { service.call }.not_to raise_error
      end
    end

    context 'with missing dates' do
      it 'raises an exception' do
        service = Reservation::ValidateDateRangeService.new(
          start_date: nil,
          end_date: current_date + 6.days
        )

        expect { service.call }.to raise_error("date range is not valid , please provide start date and end date")
      end
    end

    context 'with invalid start date' do
      it 'raises an exception' do
        start_date = current_date - 1.day
        end_date = current_date + 6.days

        service = Reservation::ValidateDateRangeService.new(
          start_date: start_date.to_s,
          end_date: end_date.to_s
        )

        expect { service.call }.to raise_error("start date is not valid , please provide vald one")
      end
    end

    context 'with invalid end date' do
      it 'raises an exception' do
        start_date = current_date + 1.day
        end_date = current_date - 1.day
        
        service = Reservation::ValidateDateRangeService.new(
          start_date: start_date.to_s,
          end_date: end_date.to_s
        )

        expect { service.call }.to raise_error("end date is not valid, please provide valid one")
      end
    end
  end
end