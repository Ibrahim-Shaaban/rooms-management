class Api::V1::UsersController < Api::BaseApi
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    begin
      @user = User::CreateService.new(user_name: params[:user_name], password_digest: params[:password]).call
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    rescue => e 
       render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  def sign_in
    begin
      login_data = User::SignInService.new(user_name: params[:user_name], password: params[:password]).call
      render json: login_data
    rescue => e
      render json: {error: e.message}, status: :unauthorized
    end

  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_name, :password)
    end
end
