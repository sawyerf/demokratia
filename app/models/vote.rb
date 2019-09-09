class Vote < ActiveRecord::Base
  serialize :vote, Array
end
