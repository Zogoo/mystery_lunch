module UsersHelper
  def default_deparments
    [
      'operations',
      'sales',
      'marketing',
      'risk',
      'management',
      'finance',
      'HR',
      'development and data'
    ]
  end

  def online_icon(user)
    content_tag(:span, '', class: 'online-dot') if user.active?
  end

  def current_user_edit_url
    link_to('Edit', edit_user_path(user)) if current_user.id.to_s == params[:id]
  end
end
