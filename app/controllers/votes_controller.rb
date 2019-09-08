class VotesController < ApplicationController
  def index
	@votes = Vote.all
  end
  def create
	Vote.create quest: params[:vote], for:0, against:0
    redirect_to "/"
  end
  def show
    @vote = Vote.find(params[:id])
    @votelogs = VoteLog.where(vote_id: params[:id])
  end
  def for
    if @current_user
      @vote = Vote.find(params[:id])
      @current_vote = VoteLog.where(user_id: @current_user.id, vote_id: params[:id]).first
      if not @current_vote
        @vote.update for: Vote.find(params[:id]).for + 1
        VoteLog.create user_id: @current_user.id, vote_id: params[:id], vote: 1
      elsif @current_vote.vote == 0
        @vote.update for: Vote.find(params[:id]).for + 1
        @current_vote.update vote: 1
      elsif @current_vote.vote == 1
        @vote.update for: Vote.find(params[:id]).for - 1
        @current_vote.update vote: 0
      elsif @current_vote.vote == 2
        @vote.update for: Vote.find(params[:id]).for + 1
        @vote.update against: Vote.find(params[:id]).against - 1
        @current_vote.update vote: 1
      end
    end
    redirect_to "/votes/#{params[:id]}"
  end
  def against
    if @current_user
      @vote = Vote.find(params[:id])
      @current_vote = VoteLog.where(user_id: @current_user.id, vote_id: params[:id]).first
      if not @current_vote
        @vote.update against: Vote.find(params[:id]).against + 1
        VoteLog.create user_id: @current_user.id, vote_id: params[:id], vote: 2
      elsif @current_vote.vote == 0
        @vote.update against: Vote.find(params[:id]).against + 1
        @current_vote.update vote: 2
      elsif @current_vote.vote == 2
        @vote.update against: Vote.find(params[:id]).against - 1
        @current_vote.update vote: 0
      elsif @current_vote.vote == 1
        @vote.update against: Vote.find(params[:id]).against + 1
        @vote.update for: Vote.find(params[:id]).for - 1
        @current_vote.update vote: 2
      end
    end
    redirect_to "/votes/#{params[:id]}"
  end
end
