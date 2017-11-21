require 'rails_helper'

RSpec.describe MenuItem, type: :model do

  it { should belong_to(:menu) }
  it { should belong_to(:recipe) }
end
