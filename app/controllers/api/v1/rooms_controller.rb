class Api::V1::RoomsController < Api::BaseApi
  before_action :set_room, only: %i[ show update destroy make_reservation ]
  before_action :set_reservation, only: %i[cancel_reservation]
  before_action :authenticated, only: %i[make_reservation cancel_reservation available]

  def current_ability
    @current_ability ||= RoomAbility.new(current_user, params)
  end
  authorize_resource only: %i[ cancel_reservation ]

  # GET /rooms
  def index
    @rooms = Room.all

    render json: @rooms
  end

  # GET /rooms/1
  def show
    render json: @room
  end

  # POST /rooms
  def create
    begin
      @room = Room::CreateService.new(number: params[:number], room_type: params[:room_type], price_per_night: params[:price_per_night]).call 
      Room.log("Room added: Number: #{@room.number}, Type: #{@room.room_type}, Night Price: #{@room.price_per_night}")
      render json: RoomSerializer.new(@room).serializable_hash, status: :created
    rescue => e 
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  def make_reservation
    begin
      Reservation::ValidateDateRangeService.new(start_date: params[:start_date], end_date: params[:end_date]).call
      is_room_avalilable = Room::CheckAvailableForReservationService.new(room: @room, start_date: params[:start_date], end_date: params[:end_date]).call
      raise "this room is not available fot this date range" unless is_room_avalilable
      reservation = Reservation::CreateService.new(room: @room, start_date: params[:start_date], end_date: params[:end_date], user: current_user).call
      Reservation.log("User: #{current_user.user_name} make reservation on Room: #{@room.number} From: #{reservation.start_date} To: #{reservation.end_date}")
      render json: ReservationSerializer.new(reservation).serializable_hash
    rescue => e 
      render json: {error: e.message}, status: :unprocessable_entity
    end
    
  end

  def cancel_reservation
    begin
      Reservation::CancelService.new(reservation: @reservation).call 
      # another solution : 
      # we can use worker in future instead of calling this service if we want to make complex logic and will take some time to be executed 
      # CancelReservationWorker.perform_async(params[:reservation_id])
      render json: {message: "reservation is canceled"}
    rescue => e 
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  def available
    begin
      Reservation::ValidateDateRangeService.new(start_date: params[:start_date], end_date: params[:end_date]).call
      rooms = Room::AvailableForReservationService.new(start_date: params[:start_date], end_date: params[:end_date]).call
      render json: RoomSerializer.new(rooms).serializable_hash
    rescue => e
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:number, :room_type, :price_per_night)
    end
end
