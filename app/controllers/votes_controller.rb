class VotesController < ApplicationController
  def index
	@votes = Vote.all
  end
  def create
    if @current_user
	  @vote = Vote.create quest: params[:vote], all: 0
	  Choice.create vote: @vote.id, text: "white", number: 0
	  Choice.create vote: @vote.id, text: "yes", number: 0
	  Choice.create vote: @vote.id, text: "no", number: 0
      redirect_to "/"
    else
      flash[:fail] = "Your not connect"
      redirect_to "/"
    end
  end
  def show
    @choices = Choice.where(vote: params[:id])
    @vote = Vote.find(params[:id])
    @votelogs = VoteLog.where(vote_id: params[:id])
    if @current_user
      @current_votelog = VoteLog.where(vote_id: params[:id], user_id: @current_user.id).first
    else
      @current_votelog = nil
    end
  end
  def vote
    if @current_user
      @nvote = params[:vote].to_i
      @vote = Vote.find(params[:id])
      @choice = Choice.where(vote: params[:id])
      @current_vote = VoteLog.where(user_id: @current_user.id, vote_id: params[:id]).first
      if @choice.size <= @nvote || @nvote < 0
        return 
      elsif not @current_vote
        @choice[@nvote].number = @choice[@nvote].number + 1
        @vote.all = @vote.all + 1
        VoteLog.create user_id: @current_user.id, vote_id: params[:id], vote: @nvote
      elsif @current_vote.vote == -1
        @choice[@nvote].number = @choice[@nvote].number + 1
        @vote.all = @vote.all + 1
        @current_vote.update vote: @nvote
      elsif @current_vote.vote == @nvote
        @choice[@nvote].number = @choice[@nvote].number - 1
        @vote.all = @vote.all - 1
        @current_vote.update vote: -1
      elsif @current_vote.vote != @nvote
        @choice[@nvote].number = @choice[@nvote].number + 1
        @choice[@current_vote.vote].number = @choice[@current_vote.vote].number - 1
        @current_vote.update vote: @nvote
      end
      @vote.save
      @choice.each do |chc|
        chc.save
      end
    else
      flash[:fail] = "Your not connect"
    end
    redirect_to "/votes/#{params[:id]}"
  end
end
