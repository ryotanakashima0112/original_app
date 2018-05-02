class SearchesController < ApplicationController
  def new
    @users = User.all.where(strength: params[:search])
  end
end
