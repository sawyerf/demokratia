class Site < ActiveRecord::Base
  def json
    return {
      :type => "site",
      :domain => self.domain,
      :key => self.itskey
    }.to_json
  end
end
