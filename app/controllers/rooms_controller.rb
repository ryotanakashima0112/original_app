class RoomsController < ApplicationController
  before_action :require_user_logged_in
  def show
    @room = Room.find(params[:id])
    @room.battle_id = @room.battle.id
    @comment = @room.comments.build
    @comments = @room.comments.order('created_at ASC').page(params[:page])
    if @room.battle.user_id == current_user.id
      @user = User.find(@room.battle.match_id)
    else
      @user = User.find(@room.battle.user_id)
    end
  end
 
  def new
    @room = Room.new
    @battle = Battle.find(params[:battle_id])
  end
  
  def create
    @battle = Battle.find(params[:battle_id])
    @room = Room.find_by(battle_id: @battle.id)
    if @room
      redirect_to battle_room_url(battle_id: @battle.id, id: @room.id)
    else
      @room = @battle.build_room(room_params)
        if @room.save
         flash[:success] = "トークルームを作成しました"
         redirect_to battle_room_url(battle_id: @battle.id, id: @room.id)
        else
         flash.now[:danger] = "トークルームの作成に失敗しました"
          render :new
        end
    end
  end

  def destroy
  end
  
  private
  
  def room_params
    params.require(:room).permit(:name)
  end
end
