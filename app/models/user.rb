class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable

  mount_uploader :photo, PhotoUploader
  enum status: %i[active suspended]

  # Validations
  validates :email, uniqueness: true
  validates :username, uniqueness: true

  # Email is not required to use it
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
