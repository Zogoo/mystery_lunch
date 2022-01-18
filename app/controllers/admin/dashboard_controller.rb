class Admin::DashboardController < ApplicationController
  layout 'admin'

  def index
    page = params[:page] || 1
    @active_users = User.active.count
    @suspendend_users = User.suspended.count
    @deparment_count = User.pluck(:department).uniq.size
    @users = User.all.order(department: 'ASC').page(page)
    @user_by_dep = @users.group_by(&:department)
  end
end
