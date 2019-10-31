class Instance::GlobalRequest
  def initialize
    @ret = nil
  end

  def sendvote(json, site_key)
    headers = {
      "Authorization" => site_key,
      "Content-Type" => "application/json"
    }

    http = Net::HTTP.new("localhost", 8080)
    http.use_ssl = false
    request = Net::HTTP::Post.new("/inbox", headers)
    request.body = json
    begin
      return http.request(request)
    rescue => e
      @ret = e.message
      return nil
    end
  end

  def vote(vote, votelog, nvote)
    json = votelog.json_inbox(nvote)
    site_key = Site.find(vote.site_id).mykey

    res = self.sendvote(json, site_key)
    if not res
      @ret = "Server is not available"
    elsif res.code == "200"
      Instance::JsonToDb.new.parse_post(res.body, vote, votelog)
    else
      @ret = "Fail code: `" + res.code + "`"
    end
    return @ret
  end
end
