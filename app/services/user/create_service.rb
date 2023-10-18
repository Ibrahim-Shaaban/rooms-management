class User::CreateService

    def initialize(user_name:, password_digest:)
        @user_name = user_name
        @password_digest = password_digest
    end

    def call 
        check_data_existed
        create_user
    end

    private

    def check_data_existed
        if @user_name.nil? || @password_digest.nil?
            raise "user_name or password digest not found , please provide them"
        end
    end

    def create_user
        User.create!(user_name: @user_name.downcase, password: @password_digest)
    end
end