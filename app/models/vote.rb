class Vote < ActiveRecord::Base
  def json
    return {
      :id => self.real_id,
      :quest => self.quest,
      :description => self.description,
      :published => self.published,
      :status => self.voter_count,
      :winner => self.winner,
      :site => Site.find(self.site_id).domain,
      :voter_count => self.voter_count,
      }.to_json
  end
  def isend?
    if self.status > 0
      return TRUE
    end
    settings = ApplicationSetting.all.first
    if settings.vote_timeline.to_i * 86400 + self.published.to_i <= Time.now.to_i
      if (User.all.size * settings.vote_min_valid) / 100 > self.voter_count
        self.status = 2;
      else
        self.winner = self.winner?
        self.status = 1
        if self.winner == -2
          self.status = 3
        end
      end
      self.save
      return TRUE
    end
    return FALSE
  end
  def winner?
    chc = Choice.where(vote_id: self.id).order('vote_count DESC')
    if chc[0].vote_count == chc[1].vote_count
      return -2
    else
      return chc.first.id
    end
  end
end
