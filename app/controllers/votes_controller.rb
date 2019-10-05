class VotesController < ApplicationController
  def index
	@votes = Vote.all
  end
  def create
    if @current_user
	  @vote = Vote.new
      @vote.update quest: params[:vote],
        description: "yes ma men",
        published: Time.now,
        choice_count: 3,
        site_id: 1,
        real_id: @vote.id,
        voter_count: 0
	  Choice.create vote_id: @vote.id, text: "white", vote_count: 0, site_id: 1
	  Choice.create vote_id: @vote.id, text: "yes", vote_count: 0, site_id: 1
	  Choice.create vote_id: @vote.id, text: "no", vote_count: 0, site_id: 1
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
      @current_votelog = VoteLog.where(vote_id: params[:id], voter_hash: @current_user.voter_hash).first
    else
      @current_votelog = nil
    end
  end

  def votelocal(vote)
    nvote = params[:vote].to_i
    votelog = VoteLog.where(voter_hash: @current_user.voter_hash, vote_id: params[:id]).first
    if vote.choice_count <= nvote or nvote < 0
      return 
    elsif votelog and votelog.vote == nvote
      nvote = -1
    end
    vote.vote(nvote, @current_user.voter_hash)
  end

  def voteglobal(vote)
    nvote = params[:vote].to_i
    votelog = VoteLog.where(voter_hash: @current_user.voter_hash, vote_id: params[:id]).first
    if vote.choice_count <= nvote or nvote < 0
      return 
    elsif votelog and votelog.vote == nvote
      nvote = -1
    end
  end

  def vote
    vote = Vote.find(params[:id])
    if not @current_user
      flash[:fail] = "Your not connect"
    elsif vote.site_id != 1
      nil
    elsif vote.isend?
      flash[:fail] = "Vote is end"
    elsif vote.site_id == 1
      self.votelocal(vote)
    end
    redirect_to "/votes/#{params[:id]}"
  end
end
