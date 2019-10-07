class Choice < ActiveRecord::Base
  include Updated

  def json
    return {
      :type => "choice",
      :vote_id => self.vote_id,
      :text => self.text,
      :vote_count => self.vote_count,
      :site => Site.find(self.site_id).domain
    }.to_json
  end

  def outbox_json
    return {
      :type => "choice",
      :vote_id => self.vote_id,
      :index => self.index,
      :text => self.text,
      :vote_count => self.vote_count,
    }
  end

end
