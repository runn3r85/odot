class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        signed_token = Rails.application.message_verifier(:remember_me).generate(user.id)
        cookies.permanent.signed[:remember_me_token] = signed_token
      end
      session[:user_id] = user.id
      flash[:success] = "Thanks for logging in!"
      redirect_to todo_lists_path
    else
      flash[:error] = "There was a problem logging in. Please check your e-mail and password."
      render action: 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    flash[:notice] = "You have been successfully logged out."
    redirect_to root_url
  end
end
