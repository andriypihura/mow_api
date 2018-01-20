require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { should belong_to(:user) }
  it { should belong_to(:recipe) }
  it { should validate_presence_of(:message) }
end
