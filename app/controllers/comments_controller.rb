class CommentsController < ApplicationController
  before_action :correct_user, only: [:destroy]
  
  def create
    @room = Room.find(params[:room_id])
    @battle = Battle.find(@room.battle_id)
    @comment = @room.comments.build(comment_params)
    @comment.from_id = params[:from_id]
    @comment.to_id = params[:to_id]
    @comment.room_id = params[:room_id]
    @user = (@room.battle.user_id == current_user.id) ? @room.battle.match : @room.battle.user
    if @comment.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to battle_room_path(battle_id: @battle.id, id: @room.id)
    else
      @comments = @room.comments.order('created_at ASC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'rooms/show'
    end
  end

  def destroy
    @room = Room.find(@comment.room_id)
    @battle =  Battle.find(@room.battle_id)
    @comment.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: battle_room_path(battle_id: @battle.id, id: @room.id))
  end
  
  private

  def comment_params
    params.require(:comment).permit(:content, :from_id, :to_id, :room_id)
  end
  
  def correct_user
    @comment = Comment.find_by(id: params[:id])
    @room = Room.find(@comment.room_id)
    @battle =  Battle.find(@room.battle_id)
    unless @comment
      redirect_to battle_room_path(battle_id: @battle.id, id: @room.id)
    end
  end
  
end
