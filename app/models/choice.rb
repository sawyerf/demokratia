class Choice < ActiveRecord::Base
  def json
    return {
      :type => "choice",
      :vote_id => self.vote_id,
      :text => self.text,
      :vote_count => self.vote_count,
      :site => Site.find(self.site_id).domain
    }.to_json
  end
end
