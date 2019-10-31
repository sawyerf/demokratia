class Instance::Fetch
  def initialize(domain)
    site = Site.where(domain: domain).first
    self.lastup = 0
    self.domain = domain
    self.key = site.mykey
  end

  def get
    http = Net::HTTP.new(self.domain, 443)
    http.use_ssl = true
    http['Authorization'] = self.key
    data = http.get("/outbox?updated=" + self.lastup.to_s)
    return data
  end

  def update 
    data = self.get()
    Instance::JsonToDb.new().parse_outbox(data.body)
  end
end
