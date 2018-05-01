class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_items, dependent: :destroy

  validates :title, presence: true
end
