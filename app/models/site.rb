class Site < ActiveRecord::Base
  def json
    return {
      :domain => self.domain,
      :key => self.itskey
    }.to_json
  end
end
