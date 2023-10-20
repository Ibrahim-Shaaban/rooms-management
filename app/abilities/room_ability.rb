class RoomAbility
    include CanCan::Ability
    def initialize(user, params)
      case params[:action]

      when 'cancel_reservation'
        can :cancel_reservation, Room if Authorization::Room::CanUserCancelReservationService.new(user: user, reservation_id: params[:reservation_id]).call
      

      else
        false
      end
    end
  
  end