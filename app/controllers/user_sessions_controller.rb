class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Thanks for loggin in!"
      redirect_to todo_lists_path
    else
      flash[:error] = "There was a problem logging in. Please check your e-mail and password."
      render action: 'new'
    end
  end
end
