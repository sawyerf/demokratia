module Updated
  extend ActiveSupport::Concern

  included do
    before_update :updated_update
    after_create :updated_create
  end

  def updated_create
    self.update updated: nil
  end

  def updated_update
    self.updated = Time.now
  end
end
