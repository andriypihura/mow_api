class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order('created_at DESC') }
  has_many :likes

  validates :title, presence: true

  scope :for_all, -> { where(visibility: 'public') }

  def public?
    visibility == 'public'
  end

  def likes_count
    likes.active.count
  end

  def liked_by_user(user)
    likes.active.where(user_id: user&.id).any?
  end
end
