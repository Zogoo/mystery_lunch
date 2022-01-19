module Admin::DashboardHelper
  def last_added_user(users)
    users.max_by(&:created_at)
  end

  def all_paired_users(users)
    MysteryPair.where(user: users).or(MysteryPair.where(partner: users))
  end

  def txt_pair_completed(users)
    users.count == all_paired_users(users).count ? t('dashboard.info.status_complete') : t('dashboard.info.status_inprogress')
  end

  def pair_progress(users)
    (all_paired_users(users).count / users.count) * 100
  end
end
