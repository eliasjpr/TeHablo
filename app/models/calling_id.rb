class CallingId < ActiveRecord::Base
  belongs_to :user

  validates :call_id, presence: true

  validates :call_id, uniqueness: {:scope => :user_id}


end
