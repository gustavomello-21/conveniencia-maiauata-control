class LoginController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  layout false, only: [:new]

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Bem-vindo, #{user.email}!"
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso."
  end
end
