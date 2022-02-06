class Admin::BaseController < ApplicationController
  include AuthorizationChecker
  rescue_from Error::UnAuthorizedRequest, with: :respond_unauthorized_req

  before_action :authenticate_user!
  before_action :require_admin_previledge!

  def respond_unauthorized_req
    respond_to do |format|
      format.html do
        flash[:alert] = t('common.errors.unauthorized_request')
        redirect_to users_path
      end
      format.json { render json: { error: t('common.errors.unauthorized_request') }, status: :unauthorized }
    end
  end
end
