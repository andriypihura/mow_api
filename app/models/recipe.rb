class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes

  validates :title, presence: true

  def public?
    visibility == 'public'
  end
end
