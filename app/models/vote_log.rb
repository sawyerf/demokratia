class VoteLog < ActiveRecord::Base
  def json
    return {
      :vote_id => self.vote_id,
      :vote => self.vote,
      :site => Vote.find(self.site_id).domain,
      :voter_hash => self.vote_hash
    }.to_json
  end
end
