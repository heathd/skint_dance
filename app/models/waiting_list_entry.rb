class WaitingListEntry < ActiveRecord::Base
  belongs_to :reservation
end