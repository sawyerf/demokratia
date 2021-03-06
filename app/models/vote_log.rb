class VoteLog < ActiveRecord::Base
  include Updated
  def json
    return {
      :type => "votelog",
      :vote_id => self.vote_id,
      :vote => self.vote,
      :site => Site.find(self.site_id).domain,
      :voter_hash => self.voter_hash
    }.to_json
  end

  def json_inbox(nvote)
    vote = Vote.find(self.vote_id)
    return {
      #:site_key => site_key,
      :item => {
        :type => "vote",
        :vote_id => vote.real_id,
        :vote => nvote,
        :voter_hash => self.voter_hash
      }
    }.to_json
  end

  def outbox_json
    return {
      :type => "votelog",
      :vote_id => self.vote_id,
      :vote => self.vote,
      :voter_hash => self.voter_hash
    }
  end

end
