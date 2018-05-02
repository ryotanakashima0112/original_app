class BattlesController < ApplicationController
  before_action :require_user_logged_in
  
 def show
   @battle = Battle.find(params[:id])
   if @battle.user_id == current_user.id
     @user = User.find(@battle.match_id)
   else
     @user = User.find(@battle.user_id)
   end
 end
 
 def done
   @battle = Battle.find(params[:id])
   @battle.doing = true
   @battle.save
   redirect_to current_user
 end
  
  def create
    @user = User.find(params[:match_id])
    user = @user
    current_user.request_battle_to(user)
    flash[:success] = '対戦を申し込みました'
    redirect_to current_user
  end

  def destroy
    @battle = Battle.find(params[:id])
    if @battle.status == 0 && @battle.doing == false
     @battle.destroy
     flash[:success] = "対戦申し込みを取り消しました"
     redirect_to current_user
   end
  end

  def update
    @battle = Battle.find(params[:id])
    if params[:commit] == "承認する" && @battle.status == 0
      @battle.update(status: 1)
      @battle.save
      flash[:success] = "マッチングが成立しました"
      redirect_to current_user
    else
      @battle.update(status: 2)
      @battle.save
      flash[:success] = "対戦申し込みを拒否しました"
      redirect_to current_user
    end
  end
end
