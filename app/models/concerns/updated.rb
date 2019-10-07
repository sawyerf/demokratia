module Updated
  extend ActiveSupport::Concern

  included do
    before_update :updated
    after_create :updated
  end

  def updated
    self.updated = Time.now
  end
end
