class TenantRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :for_user, ->(user) { where(user_id: user.id) }
end
