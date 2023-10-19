require 'rails_helper'

describe Reservation::ValidateDateRangeService do
  describe '#call' do
    context 'with valid date range' do
      it 'does not raise any exceptions' do
        service = Reservation::ValidateDateRangeService.new(
          start_date: '2023-10-20',
          end_date: '2023-10-25'
        )

        expect { service.call }.not_to raise_error
      end
    end

    context 'with missing dates' do
      it 'raises an exception' do
        service = Reservation::ValidateDateRangeService.new(
          start_date: nil,
          end_date: '2023-10-25'
        )

        expect { service.call }.to raise_error("date range is not valid , please provide start date and end date")
      end
    end

    context 'with invalid start date' do
      it 'raises an exception' do
        service = Reservation::ValidateDateRangeService.new(
          start_date: '2022-10-20',
          end_date: '2023-10-25'
        )

        expect { service.call }.to raise_error("start date is not valid , please provide vald one")
      end
    end

    context 'with invalid end date' do
      it 'raises an exception' do
        service = Reservation::ValidateDateRangeService.new(
          start_date: '2023-10-20',
          end_date: '2023-10-18'
        )

        expect { service.call }.to raise_error("end date is not valid, please provide valid one")
      end
    end
  end
end