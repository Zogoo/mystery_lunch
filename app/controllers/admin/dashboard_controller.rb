class Admin::DashboardController < Admin::BaseController
  layout 'admin'

  def index
    page = params[:page] || 1
    @active_users = User.active.count
    @suspendend_users = User.suspended.count
    @deparment_count = User.pluck(:department).uniq.size
    @users = User.all.order(department: 'ASC').by_department(search_value).page(page)
    @user_by_dep = @users.group_by(&:department)
  end

  private

  def search_value
    params.permit(:search_value)[:search_value]
  end
end
