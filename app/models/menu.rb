class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_items, dependent: :destroy

  validates :title, presence: true

  scope :visible, -> { where(visibility: 'public') }
  scope :filter_by, lambda { |params|
    visible
      .by_title(params['title'])
      .by_calories(params['calories_from'], params['calories_to'])
  }
  scope :by_calories, lambda { |start_range, end_range|
    where("menus.calories <= ?", end_range)
      .where("menus.calories >= ?", start_range) if start_range && end_range && start_range < end_range
  }
  scope :by_title, ->(t) { where('lower(menus.title) ILIKE ?', "%#{t.downcase}%") if t }


  def update_calories
    update_attribute(:calories, menu_items.sum { |menu_item| menu_item.recipe.calories })
  end
end
