class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :confirmable, :trackable

  mount_uploader :photo, PhotoUploader
  enum status: %i[active suspended]

  attr_accessor :partners, :connection, :selected
end
