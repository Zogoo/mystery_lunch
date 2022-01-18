module AuthorizationChecker
  extend ActiveSupport::Concern

  module Error
    class UnAuthorizedRequest < StandardError; end
  end

  def require_admin_previledge!
    raise Error::UnAuthorizedRequest unless current_user.admin?
  end
end
