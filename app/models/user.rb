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
  validates :username, uniqueness: true
  validates_inclusion_of :department, in: default_deparments

  # Email is not required to use it
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
