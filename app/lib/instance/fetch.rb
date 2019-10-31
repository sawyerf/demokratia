class Instance::Fetch
  def initialize(domain)
    @site = Site.where(domain: domain).first
    @domain = domain
    @lastup = 0
  end

  def get
    http = Net::HTTP.new(@domain, 8080)
    http.use_ssl = false
    headers = {
      "Authorization" => @site.itskey
    }
    data = http.get("/outbox?updated=" + @lastup.to_s, headers = headers)
    return data
  end

  def update 
    puts("[0]")
    data = self.get()
    puts("[1]")
    Instance::JsonToDb.new().parse_outbox(data.body, @site.id)
  end
end
