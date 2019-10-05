class InboxController < ApplicationController
 skip_before_action :verify_authenticity_token

  def vote(item)
    votelog = VoteLog.where(vote_id: item[:vote_id], site_id: 1, voter_hash: item[:voter_hash]).first
    vote = Vote.find(item[:vote_id])
    choices = Choice.where(vote_id: item[:vote_id], site_id: 1)
    if vote.choice_count <= item[:vote] or item[:vote] < -1
      head 406
      return nil
    elsif votelog
      if item[:vote] == votelog.vote
        nil
      elsif item[:vote] == -1
        choices[votelog.vote].update vote_count: choices[votelog.vote].vote_count - 1
        vote.update voter_count: vote.voter_count - 1
      else
        choices[item[:vote]].update vote_count: choices[item[:vote]].vote_count + 1
        if votelog.vote != -1
          choices[votelog.vote].update vote_count: choices[votelog.vote].vote_count - 1
        else
          vote.update voter_count: vote.voter_count + 1
        end
      end
      votelog.update vote: item[:vote]
      # head 200
      return votelog.json
    else
      votelog = VoteLog.create voter_hash: item[:voter_hash],
         site_id: 1,
         vote_id: item[:vote_id],
         vote: item[:vote]
      if item[:vote] != -1
        vote.update voter_count: vote.voter_count + 1
        choices[item[:vote]].update vote_count: choices[item[:vote]].vote_count + 1
      end
      # head 201
      return votelog.json
    end
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
    site = Site.where(itskeys: params[:site_key])
    if site
      item = params[:item]
      if item[:type] == "vote"
        @body = self.vote(item)
      elsif item[:type] == "createvote"
        @body = self.createvote(item)
      end
    else
      head 401
    end
  end
end
