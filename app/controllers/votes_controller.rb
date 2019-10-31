require 'json'

class VotesController < ApplicationController
  def index
	  @votes = Vote.all
  end
  def create
    if @current_user
	    @vote = Vote.create
      @vote.update quest: params[:vote],
          description: "yes ma men",
          published: Time.now,
          choice_count: 3,
          site_id: 1,
          real_id: @vote.id,
          voter_count: 0
	    Choice.create vote_id: @vote.id, text: "white", vote_count: 0, site_id: 1, index: 1
	    Choice.create vote_id: @vote.id, text: "yes", vote_count: 0, site_id: 1, index: 2
	    Choice.create vote_id: @vote.id, text: "no", vote_count: 0, site_id: 1, index: 3
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
    vote.vote(nvote, @current_user.voter_hash, 1)
  end

  def sendvote_inbox(site_id, votelog, nvote)
    site_key = Site.find(site_id).mykey
    json = votelog.json_inbox(nvote)
    headers = {
      "Authorization" => site_key,
      "Content-Type" => "application/json"
    }
    http = Net::HTTP.new("localhost", 8080)
    http.use_ssl = false
    request = Net::HTTP::Post.new("/inbox", headers)
    request.body = json
    begin
      return http.request(request)
    rescue => e
      flash[:fail] = e.message
      return nil
    end
  end

  def voteglobal(vote)
    nvote = params[:vote].to_i
    votelog = VoteLog.where(voter_hash: @current_user.voter_hash, vote_id: params[:id], site_id: 1).first
    if vote.choice_count <= nvote or nvote < 0
      return 
    elsif not votelog
      votelog = VoteLog.create vote_id: vote.id, vote: -1, site_id: 1, voter_hash: @current_user.voter_hash
    elsif votelog.vote == nvote
      nvote = -1
    end
    response = sendvote_inbox(vote.site_id, votelog, nvote)
    if not response
      flash[:fail] = "Server is not available"
    elsif response.code == "200"
      Instance::JsonToDb.new.parse_post(response.body, vote, votelog)
    else
      flash[:fail] = "Fail code: `" + response.code + "`"
    end
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
end
