class VotesController < ApplicationController
  def index
	@votes = Vote.all
  end
  def create
    if @current_user
	  @vote = Vote.create quest: params[:vote], description: "yes ma men", published: Time.now, voter_count: 0
	  Choice.create vote_id: @vote.id, text: "white", vote_count: 0
	  Choice.create vote_id: @vote.id, text: "yes", vote_count: 0
	  Choice.create vote_id: @vote.id, text: "no", vote_count: 0
      redirect_to "/"
    else
      flash[:fail] = "Your not connect"
      redirect_to "/"
    end
  end
  def show
    @choices = Choice.where(vote_id: params[:id])
    @vote = Vote.find(params[:id])
    @votelogs = VoteLog.where(vote_id: params[:id])
    if @current_user
      @current_votelog = VoteLog.where(vote_id: params[:id], user_id: @current_user.id).first
    else
      @current_votelog = nil
    end
  end
  def vote
    @vote = Vote.find(params[:id])
    if @vote.isend?
      flash[:fail] = "Vote is end"
    elsif @current_user
      nvote = params[:vote].to_i
      @choice = Choice.where(vote_id: params[:id])
      @current_vote = VoteLog.where(user_id: @current_user.id, vote_id: params[:id]).first
      if @choice.size <= nvote || nvote < 0
        return 
      elsif not @current_vote
        @choice[nvote].vote_count = @choice[nvote].vote_count + 1
        @vote.voter_count = @vote.voter_count + 1
        VoteLog.create user_id: @current_user.id, vote_id: params[:id], vote: nvote
      elsif @current_vote.vote == -1
        @choice[nvote].vote_count = @choice[nvote].vote_count + 1
        @vote.voter_count = @vote.voter_count + 1
        @current_vote.update vote: nvote
      elsif @current_vote.vote == nvote
        @choice[nvote].vote_count = @choice[nvote].vote_count - 1
        @vote.voter_count = @vote.voter_count - 1
        @current_vote.update vote: -1
      elsif @current_vote.vote != nvote
        @choice[nvote].vote_count = @choice[nvote].vote_count + 1
        @choice[@current_vote.vote].vote_count = @choice[@current_vote.vote].vote_count - 1
        @current_vote.update vote: nvote
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
