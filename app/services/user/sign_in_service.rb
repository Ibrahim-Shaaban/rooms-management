class User::SignInService

    def initialize(user_name:, password:)
        @user_name = user_name
        @password = password
    end

    def call 
        handle_sign_in
    end

    private

   def handle_sign_in
    unless @user_name.present? || @password.present?
        raise "Invalid credentials"
    end
    user = User.find_by(user_name: @user_name.downcase)
    unless user.present?
        raise "Invalid credentials"
    end

    unless user.authenticate(@password).present?
        raise "Invalid credentials"
    end

    # generate token
    expires_at = Time.zone.now + 4.days
    token =JsonWebToken.encode({id: user.id}, expires_at)
    {token: token, expires_at: expires_at}
   end
end