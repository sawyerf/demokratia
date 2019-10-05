class VoteLog < ActiveRecord::Base
  def json
    return {
      :type => "votelog",
      :vote_id => self.vote_id,
      :vote => self.vote,
      :site => Site.find(self.site_id).domain,
      :voter_hash => self.voter_hash
    }.to_json
  end
end
