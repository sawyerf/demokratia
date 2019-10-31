class Instance::JsonToDb
  def parse_post(json, vote, votelog)
      items = JSON.parse(json)
      items["items"].each do |item|
        if item["type"] == "vote"
          choices = Choice.where(vote_id: vote.id)
          vote.update voter_count: item["voter_count"], status: item["status"], winner: item["winner"]
          i = 0
          item["choices"].each do |vote_count|
            choices[i].update vote_count: vote_count
            i = i + 1
          end
        elsif item["type"] == "votelog"
          votelog.update vote: item["vote"]
        end
      end
  end
  def parse_outbox(json, site_id)
      items = JSON.parse(json)
      items["items"] do |item|
        if item[:type] == "vote"
          vote = Vote.where(real_id: item[:id], site: site_id).first
          if vote
            vote.update status: item[:status],
                        winner: item[:winner]
                        voter_count: item[:voter_count]
          else
            vote.create quest: item[:quest],
                        description: item[:description],
                        published: item[:description].to_date,
                        winner: item[:winner],
                        voter_count: item[:voter_count],
                        choice_count: item[:choice_count],
                        site_id: site_id,
                        real_id: item[:id]
        #elsif item[:type] == "votelog"
        #  vote = Vote.find(item[:vote_id])
        #  if vote
        #    vote.vote(item[:vote], item[:voter_hash], site_id)
        #  end
        elsif item[:type] == "choice"
          vote = Vote.where(real_id: item[:vote_id], site_id: site_id).first
          if vote
            choice = Choice.where(vote_id: vote.id, index: item[:index])
            if choice
              choice.update vote_count: item[:vote_count]
            else
              choice.create vote_id: vote.id,
                            text: item[:text],
                            vote_count: item[:vote_count],
                            index: item[:index]
            end
          end
      end
  end
end
