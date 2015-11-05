class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      #just for checking out gitgutter
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Unsuccessful activation!"
      redirect_to root_path
    end
  end
end
