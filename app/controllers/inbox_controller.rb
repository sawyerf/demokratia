class InboxController < ApplicationController
 skip_before_action :verify_authenticity_token
  def Recv
    current_site = Site.where(itskeys: params[:site_key])
    if current_site
      params[:items].each do |item|
        if item[:type] == "vote"
          current_votelog = VoteLog.where(vote_id: item[:vote_id], site_id: 1, voter_hash: item[:voter_hash]).first
          current_vote = Vote.find(item[:vote_id])
          if current_vote.choice_count <= item[:vote] or item[:vote] < -1
            head 406            
          elsif current_votelog
            if item[:vote] == current_votelog.vote
              nil
            elsif item[:vote] == -1
              current_vote.update voter_count: current_vote.voter_count - 1
            else
              current_vote.update voter_count: current_vote.voter_count + 1
            end
            current_votelog.update vote: item[:vote]
            head 200
          else
            VoteLog.create voter_hash: item[:voter_hash], site_id: 1, vote_id: item[:vote_id], vote: item[:vote]
            current_vote.update voter_count: current_vote.voter_count + 1
            head 201
          end
        elsif item[:type] == "createvote"
          current_vote = Vote.new
          current_vote.update quest: item[:quest],
            description: item[:description],
            published: Time.now,
            choice_count: item[:choices].size + 1,
            site_id: 1,
            real_id: current_vote.id,
            voter_count: 0
          Choice.create vote_id: current_vote.id, text: "white", vote_count: 0
          item[:choices].each do |choice|
            Choice.create vote_id: current_vote.id, text: choice, vote_count: 0
          end
          head 201
        end
      end
    else
      head 401
    end
  end
  def SendVote
  end
end
