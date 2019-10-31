class InboxController < ApplicationController
 skip_before_action :verify_authenticity_token

  def vote(item, site_id)
    vote = Vote.find(item[:vote_id])
    if vote.choice_count <= item[:vote] or item[:vote] < -1 
      head 406
      return nil
    if not vote.isend?
      vote.vote(item[:vote], item[:voter_hash], site_id)
    end
    votelog = VoteLog.where(vote_id: item[:vote_id], voter_hash: item[:voter_hash], site_id: site_id).first
    return vote.json_reinbox(votelog)
  end

  def createvote(item)
    vote = Vote.new
    vote.save
    vote.update quest: item[:quest],
      description: item[:description],
      published: Time.now,
      choice_count: item[:choices].size + 1,
      site_id: 1,
      real_id: vote.id,
      voter_count: 0
    Choice.create vote_id: vote.id, text: "white", vote_count: 0, site_id: 1
    item[:choices].each do |choice|
      Choice.create vote_id: vote.id, text: choice, vote_count: 0, site_id: 1
    end
    # head 201
    return vote.json
  end

  def recv
    site_key = request.headers["Authorization"]
    site = Site.where(itskey: site_key).first
    if site
      item = params[:item]
      if item[:type] == "vote"
        @body = self.vote(item, site.id)
      elsif item[:type] == "createvote"
        @body = self.createvote(item)
      else
        head 400
      end
    else
      head 401
    end
  end
end
