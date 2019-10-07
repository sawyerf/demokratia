class Vote < ActiveRecord::Base
  include Updated

  def outbox_json
    return {
      :type => "vote",
      :id => self.id,
      :quest => self.quest,
      :description => self.description,
      :published => self.published,
      :status => self.voter_count,
      :winner => self.winner,
      :voter_count => self.voter_count,
    }
  end

  def json
    return {
      :items => [
        {
          :type => "vote",
          :id => self.real_id,
          :quest => self.quest,
          :description => self.description,
          :published => self.published,
          :status => self.voter_count,
          :winner => self.winner,
          :site => Site.find(self.site_id).domain,
          :voter_count => self.voter_count,
        }
      ]
    }.to_json
  end

  def json_reinbox(votelog)
    lchc = Array.new()
    choices = Choice.where(vote_id: self.id)
    choices.each do |chc|
      lchc = lchc.push(chc.vote_count)
    end
    json = {
      :items => [
        {
          :type => "vote",
          :id => self.real_id,
          :status => self.status,
          :winner => self.winner,
          :voter_count => self.voter_count,
          :choices => lchc
        }
      ]
    }
    if votelog
        json[:items].push({
          :type => "votelog",
          :vote => votelog.vote
        })
    end
    return json.to_json
  end

  def vote(nvote, voter_hash)
    votelog = VoteLog.where(vote_id: self.id, voter_hash: voter_hash).first
    choices = Choice.where(vote_id: self.id, site_id: 1)
    if votelog
      if nvote == -1
        choices[votelog.vote].update vote_count: choices[votelog.vote].vote_count - 1
        self.update voter_count: self.voter_count - 1
      else
        choices[nvote].update vote_count: choices[nvote].vote_count + 1
        if votelog.vote == -1
          self.update voter_count: self.voter_count + 1
        else
          choices[votelog.vote].update vote_count: choices[votelog.vote].vote_count - 1
        end
      end
      votelog.update vote: nvote
    else
      votelog = VoteLog.create voter_hash: voter_hash,
         site_id: 1,
         vote_id: self.id,
         vote: nvote
      if nvote != -1
        self.update voter_count: self.voter_count + 1
        choices[nvote].update vote_count: choices[nvote].vote_count + 1
      end
    end
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
