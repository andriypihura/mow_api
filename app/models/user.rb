class User < ApplicationRecord
  has_many :recipes
  has_many :favorites
  has_many :comments
  has_many :likes

  validates :name, uniqueness: true
end
