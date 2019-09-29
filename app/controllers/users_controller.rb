require 'digest/md5'

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
  def generate_voter_hash
    while true
      random = (0...100).map { (rand(255)).chr }.join
      voter_hash = Digest::MD5.hexdigest(random)
      vote = User.where(voter_hash: voter_hash).first
      unless vote
        return voter_hash
      end
    end
  end
  def connect
    unless session[:user_id]
      @current_user = User.where(name: params[:name]).first
      if @current_user and BCrypt::Password.new(@current_user.passwd) == params[:passwd]
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
    reguser = User.where(name: params[:name]).first
    if reguser
      flash[:fail] = "Name already exist"
    elsif params[:passwd] == ""
      flash[:fail] = "Password is empty"
    else
      if params[:passwd] == params[:repeat]
        User.create name: params[:name], passwd: BCrypt::Password.create(params[:passwd]), voter_hash: generate_voter_hash()
        flash[:success] = "Register success"
      else
        flash[:fail] = "Password not match"
      end
    end
    redirect_to "/register"
  end
end
