class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @posts = Post.where(user: @user)
    @post = current_user.posts.new if @user == current_user
    @comment = Comment.new
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def friend_request
    user = User.find(params[:requested_id])
    unless current_user.out_friend_requests.any?{ |f| f.requested_id.to_i == params[:requested_id].to_i }
      fr = current_user.out_friend_requests.new
      fr.requested = user
      fr.save
      flash[:alert] = 'Friend request sent!'
    else
      flash[:alert] = "You already sent #{user.full_name} a friend request!"
    end
    redirect_to home_path
  end

  def befriend
    fr = FriendRequest.find(params[:friendship_id])
    if fr.requested == current_user && get_all_friends.none?(fr.requester)
      friendship = current_user.friendships_a.new
      friendship.one = current_user
      friendship.two = fr.requester
      friendship.save
      fr.destroy
    end
    redirect_to home_path
  end

  def unfriend
    friendship = Friendship.where(one_id: params[:friendship_id], two_id: current_user.id).or(
      Friendship.where(one_id: current_user.id, two_id: params[:friendship_id])
    ).first
    friendship.destroy
    redirect_to home_path
  end

  def notifications
    @sent_requests = current_user.out_friend_requests
    @received_requests = current_user.in_friend_requests
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end

    def get_all_friends
      current_user.friendships.map{ |f| f.two }
    end
end
