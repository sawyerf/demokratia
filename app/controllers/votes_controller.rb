class VotesController < ApplicationController
  def index
	@votes = Vote.all
  end
  def create
	Vote.create quest: params[:vote], for:0, against:0
  end
  def show
    @vote = Vote.find(params[:id])
  end
  def for
    Vote.find(params[:id]).update for: Vote.find(params[:id]).for + 1
    redirect_to "/votes/#{params[:id]}"
  end
  def against
    Vote.find(params[:id]).update against: Vote.find(params[:id]).against + 1
    redirect_to "/votes/#{params[:id]}"
  end
end
