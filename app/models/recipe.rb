class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order('created_at DESC') }
  has_many :likes

  validates :title, presence: true
  validates :ingredients, presence: true
  validates :text, presence: true

  scope :for_all, -> { where(visibility: 'public') }
  scope :by_type, lambda { |type, user_id|
    if type == 'my'
      where(user_id: user_id)
    elsif type == 'likes'
      joins(:likes).where(likes: { user_id: user_id, value: true })
    else
      where(nil)
    end
  }
  scope :filter_by, lambda { |params|
    for_all
      .by_title(params['title'])
      .by_time_consuming(params['time_consuming_from'], params['time_consuming_to'])
      .by_calories(params['calories_from'], params['calories_to'])
      .by_complexity(params['complexity'])
  }
  scope :by_time_consuming, lambda { |start_range, end_range|
    where("recipes.time_consuming <= ?", end_range)
      .where("recipes.time_consuming >= ?", start_range) if start_range && end_range && start_range < end_range
  }
  scope :by_calories, lambda { |start_range, end_range|
    where("recipes.calories <= ?", end_range)
      .where("recipes.calories >= ?", start_range) if start_range && end_range && start_range < end_range
  }
  scope :by_complexity, ->(c) { where(complexity: c) if c }
  scope :by_title, ->(t) { where('lower(recipes.title) ILIKE ?', "%#{t.downcase}%") if t }

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
