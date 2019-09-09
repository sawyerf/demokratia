class UsersController < ApplicationController
  def login
    if @current_user
      redirect_to "/"
    end
  end
  def register
    @users = User.all
  end
  def disconnect
    session[:user_id] = nil;
    redirect_to "/"
  end
  def connect
    unless session[:user_id]
      @current_user = User.where(name: params[:name], passwd: params[:passwd]).first
      if @current_user
        session[:user_id] = @current_user.id
        flash[:success] = "Welcome " + @current_user.name
        redirect_to "/"
      else
        flash[:fail] = "Fail to connect"
        redirect_to "/login"
      end
    else
      flash[:fail] = "You already connect"
      redirect_to "/"
    end
  end
  def create
    @reguser = User.where(name: params[:name]).first
    print @register
    if @reguser
      flash[:fail] = "Name already exist"
      redirect_to "/register"
    else
      if params[:passwd] == params[:repeat]
        User.create name: params[:name], passwd: params[:passwd]
        flash[:success] = "Register success"
        redirect_to "/register"
      else
        flash[:fail] = "Password not match"
        redirect_to "/register"
      end
    end
  end
end
