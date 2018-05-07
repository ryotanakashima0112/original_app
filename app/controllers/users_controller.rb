class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :index]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @match_battles = Battle.where(user_id: @user.id , status: 1, doing: false) + Battle.where(match_id: @user.id, status: 1, doing: false) if current_user == @user
    @request_battles = Battle.where(user_id: current_user.id).where(status: 0, doing: false) if current_user == @user
    @requested_battles = Battle.where(match_id: current_user.id).where(status: 0, doing: false) if current_user == @user
    hist = Battle.where("user_id = ? or match_id = ?", current_user, current_user).order("created_at")
    found = Array.new
    @histrecord = Array.new
    hist.each do |el|
      u = (el.user_id == current_user.id) ? el.match_id : el.user_id
      if(! found.include?(u))
        found << u
        @histrecord << el
      end
    end
    @count_match_people = (Battle.where(user_id: @user.id , status: 1, doing: false) + Battle.where(match_id: @user.id, status: 1, doing: false)).count  if current_user == @user
    @count_requestings = Battle.where(user_id: current_user.id).where(status: 0, doing: false).count if current_user == @user
    @count_requesters = Battle.where(match_id: current_user.id).where(status: 0, doing: false).count if current_user == @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
 
    #編集しようとしてるユーザーがログインユーザーとイコールかをチェック
    if current_user == @user
 
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を編集しました。'
      redirect_to "users/show"
    else
      flash.now[:danger] = 'ユーザー情報の編集に失敗しました。'
      render :edit
    end   
  else
    render :show
  end
   
 
end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :strength, :age, :sex, :address, :introduce)
  end
  
end
