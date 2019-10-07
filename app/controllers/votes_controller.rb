require 'json'

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

  def sendvote_inbox(site_id, votelog, nvote)
    site_key = Site.find(site_id).mykey
    json = votelog.json_inbox(nvote, site_key)
    http = Net::HTTP.new("localhost", 3001)
    http.use_ssl = false
    request = Net::HTTP::Post.new("/inbox", {'Content-Type' => 'application/json'})
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
    votelog = VoteLog.where(voter_hash: @current_user.voter_hash, vote_id: params[:id]).first
    if vote.choice_count <= nvote or nvote < 0
      return 
    elsif not votelog
      votelog = VoteLog.create vote_id: vote.id, vote: -1, site_id: vote.site_id, voter_hash: @current_user.voter_hash
    elsif votelog.vote == nvote
      nvote = -1
    end
    response = sendvote_inbox(vote.site_id, votelog, nvote)
    if not response
      return 
    elsif response.code == "200"
      items = JSON.parse(response.body)
      flash[:success] = items["items"]
      items["items"].each do |item|
        if item["type"] == "vote"
          choices = Choice.where(vote_id: vote.id)
          vote.update voter_count: item["voter_count"], status: item["status"], winner: item["winner"]
          i = 0
          item["choices"].each do |vote_count|
            choices[i].update vote_count: vote_count
            i = i + 1
          end
        elsif item["type"] == "votelog"
          votelog.update vote: item["vote"]
        end
      end
    else
      flash[:fail] = "Fail code: `" + response.code + "`"
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
