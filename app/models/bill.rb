class Bill < ActiveRecord::Base
  STATUS = [ 'Pending', 'Posted']

  has_one :user
  has_one :agent, :class_name => "User", foreign_key: "user_id"

end
