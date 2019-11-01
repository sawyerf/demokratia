class Instance::Fetch
  def initialize()
    @lastup = 0
  end

  def get(site)
    http = Net::HTTP.new(site.domain, 8080)
    http.use_ssl = false
    headers = {
      "Authorization" => site.itskey
    }
    data = http.get("/outbox?updated=" + @lastup.to_s, headers = headers)
    return data
  end

  def update(site)
    data = self.get()
    Instance::JsonToDb.new().parse_outbox(data.body, site.id)
  end

  def updateall
    newup = Time.Now.to_i
    Site.each do |site|
      if site.id != 1
        self.update(site)
      end
    end
    @lastup = newup
  end
end
