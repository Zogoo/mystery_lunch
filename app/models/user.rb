class User < ApplicationRecord
  extend UsersHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable

  mount_uploader :photo, PhotoUploader
  enum status: %i[active suspended]
  enum permission: %i[user admin]

  # Validations
  validates :email, uniqueness: true
  validates :username, uniqueness: true, presence: true, allow_blank: false
  validates_inclusion_of :department, in: default_deparments

  scope :by_department, lambda { |value|
    where('lower(department) ~ :value', value: Regexp.escape(value.to_s.downcase.strip))
  }

  scope :by_first_name, lambda { |value|
    where('lower(first_name) ~ :value', value: Regexp.escape(value.to_s.downcase.strip))
  }

  scope :by_last_name, lambda { |value|
    where('lower(last_name) ~ :value', value: Regexp.escape(value.to_s.downcase.strip))
  }

  # Email is not required since authenticating user with username 
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def cancel_future_pair!
    MysteryPair.remove_user(self)
  end

  def add_for_future_pair!
    MysteryPair.add_user(self)
  end
end
