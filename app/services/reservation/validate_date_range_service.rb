class Reservation::ValidateDateRangeService
    
    def initialize(start_date:, end_date:)
        @start_date = start_date
        @end_date = end_date
    end

    def call 
        check_date_range_existed
        check_date_range_valid
    end

    private 

    def check_date_range_existed
        valid_message = "date range is not valid , please provide start date and end date" 
        if @start_date.nil? || @end_date.nil?
            raise valid_message
        end
        
        begin
            @start_date = Date.parse(@start_date)
            @end_date = Date.parse(@end_date)
        rescue => e # to handle if incoming data is not valid date string
            raise valid_message
        end
        
    end

    # check the logic of start date and date date
    def check_date_range_valid
        raise "start date is not valid , please provide vald one" if @start_date <= Time.now
        raise "end date is not valid, please provide valid one" if @start_date >= @end_date 
    end
end