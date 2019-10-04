class InboxController < ApplicationController
 skip_before_action :verify_authenticity_token
  def Recv
    current_site = Site.where(itskeys: params[:site_key])
    if current_site
      params[:items].each do |item|
        if item[:type] == "vote"
          current_votelog = VoteLog.where(vote_id: item[:vote_id], site_id: 1, voter_hash: item[:voter_hash]).first
          current_vote = Vote.find(item[:vote_id])
          if current_vote.choice_count <= item[:vote]
            head 406            
          elsif current_votelog
            current_votelog.update vote: item[:vote]
            head 200
          else
            VoteLog.create voter_hash: item[:voter_hash], site_id: 1, vote_id: item[:vote], vote: item[:vote]
            head 201
          end
        #elsif item[:type] == "createvote"
          
        end
      end
    end
  end
  def SendVote
#    json = {
#      :type => "vote",
#      :voter_hash => @current_user.voter_hash,
#      :vote_id => params[:id]
#      :vote => params[:vote]
#    }.to_json
  end
end
