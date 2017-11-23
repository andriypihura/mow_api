class User < ApplicationRecord
  has_secure_password

  has_many :recipes
  has_many :menus
  has_many :comments
  has_many :likes

  validates :name, uniqueness: true
end
