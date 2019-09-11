class VotesController < ApplicationController
  def index
	@votes = Vote.all
  end
  def create
    if @current_user
	  Vote.create quest: params[:vote], vote: [0, 0], all: 0
      redirect_to "/"
    else
      flash[:fail] = "Your not connect"
      redirect_to "/"
    end
  end
  def show
    @vote = Vote.find(params[:id])
    @votelogs = VoteLog.where(vote_id: params[:id])
  end
  def vote
    if @current_user
      @nvote = params[:vote].to_i
      @vote = Vote.find(params[:id])
      @current_vote = VoteLog.where(user_id: @current_user.id, vote_id: params[:id]).first
      if @vote.vote.size <= @nvote || @nvote < 0
        return 
      elsif not @current_vote
        @vote.vote[@nvote] = @vote.vote[@nvote] + 1
        @vote.all = @vote.all + 1
        VoteLog.create user_id: @current_user.id, vote_id: params[:id], vote: @nvote
      elsif @current_vote.vote == -1
        @vote.vote[@nvote] = @vote.vote[@nvote] + 1
        @vote.all = @vote.all + 1
        @current_vote.update vote: @nvote
      elsif @current_vote.vote == @nvote
        @vote.vote[@nvote] = @vote.vote[@nvote] - 1
        @vote.all = @vote.all - 1
        @current_vote.update vote: -1
      elsif @current_vote.vote != @nvote
        @vote.vote[@nvote] = @vote.vote[@nvote] + 1
        @vote.vote[@current_vote.vote] = @vote.vote[@current_vote.vote] - 1
        @current_vote.update vote: @nvote
      end
      @vote.save
    else
      flash[:fail] = "Your not connect"
    end
    redirect_to "/votes/#{params[:id]}"
  end
end
