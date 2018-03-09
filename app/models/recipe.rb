class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order('created_at DESC') }
  has_many :likes

  validates :title, presence: true

  scope :for_all, -> { where(visibility: 'public') }

  def public?
    visibility == 'public'
  end
end
