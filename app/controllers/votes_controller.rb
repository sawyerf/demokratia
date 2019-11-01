require 'json'

class VotesController < ApplicationController
  def index
	  @votes = Vote.all
  end

  def postcreatevote
    if not @current_user
      flash[:fail] = "Your not connect"
      redirect_to "/"
      return 
    end
	  @vote = Vote.create
    @vote.update quest: params[:quest],
        description: params[:desc],
        published: Time.now,
        choice_count: 1, 
        site_id: 1,
        real_id: @vote.id,
        voter_count: 0
	  Choice.create vote_id: @vote.id, text: "white", vote_count: 0, site_id: 1, index: 1
    i = 2
    params[:choice].each do |chc|
      if chc != ""
        Choice.create vote_id: @vote.id, text: chc, vote_count: 0, site_id: 1, index: i
        i = i + 1
      end
    end
    @vote.update choice_count: i + 1
    redirect_to "/"
  end

  def show
    @choices = Choice.where(vote_id: params[:id])
    @vote = Vote.find(params[:id])
    @votelogs = VoteLog.where(vote_id: params[:id])
    @current_votelog = nil
    if @current_user
      @current_votelog =  VoteLog.where(vote_id: params[:id],
                          voter_hash: @current_user.voter_hash,
                          site_id: 1).first
    end
  end

  def votelocal(vote)
    nvote = params[:vote].to_i
    votelog = VoteLog.where(voter_hash: @current_user.voter_hash,
                            vote_id: params[:id],
                            site_id: 1).first
    if vote.choice_count <= nvote or nvote < 0
      return 
    elsif votelog and votelog.vote == nvote
      nvote = -1
    end
    vote.vote(nvote, @current_user.voter_hash, 1)
  end

  def voteglobal(vote)
    nvote = params[:vote].to_i
    votelog = VoteLog.where(voter_hash: @current_user.voter_hash,
                            vote_id: params[:id],
                            site_id: 1).first
    if vote.choice_count <= nvote or nvote < 0
      return 
    elsif not votelog
      votelog = VoteLog.create  vote_id: vote.id,
                                vote: -1, site_id: 1,
                                voter_hash: @current_user.voter_hash
    elsif votelog.vote == nvote
      nvote = -1
    end
    flash[:fail] = Instance::GlobalRequest.new.vote(vote, votelog, nvote)
  end

  def vote
    vote = Vote.find(params[:id])
    if not @current_user
      flash[:fail] = "Your not connect"
    elsif vote.site_id != 1
      self.voteglobal(vote)
    elsif vote.isend?
      flash[:fail] = "Vote is end"
    elsif vote.site_id == 1
      self.votelocal(vote)
    end
    redirect_to "/votes/#{params[:id]}"
  end

  def createvote
    nil
  end
end
