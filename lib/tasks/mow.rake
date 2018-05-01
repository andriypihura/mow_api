namespace :mow do
  desc 'Adds test data to the database'
  task data: :environment do
    puts 'Create Sensei'.green
    User.create(
      name: 'Sensei',
      email: 'sensei@mail.com',
      password: '12345678',
      password_confirmation: '12345678',
      roles: 'admin'
    )

    puts 'Create Wangsan'.green
    User.create(
      name: 'Wangsan',
      email: 'wangsan@mail.com',
      password: '12345678',
      password_confirmation: '12345678'
    )

    puts 'Create several recipes (100 - for random users)'.green
    100.times { FactoryGirl.create(:recipe, :public) }

    puts 'Create 2 menu for Wangsan'.green
    user = User.find_by(email: 'wangsan@mail.com')
    2.times { FactoryGirl.create(:menu, user: user) }

    puts 'Create several likes (1000 - for random, but existing, users and recipes)'.green
    User.all.each do |u|
      Recipe.offset(rand(Recipe.count)).each do |r|
        FactoryGirl.create(
          :like,
          user: u,
          recipe: r
        )
      end
    end

    puts 'Create several comments (1000 - for random, but existing, users and recipes)'.green
    1000.times do
      FactoryGirl.create(
        :comment,
        user: User.offset(rand(User.count)).first,
        recipe: Recipe.offset(rand(Recipe.count)).first
      )
    end

    puts 'Create several menu items for Wangsan'.green
    50.times do
      FactoryGirl.create(
        :menu_item,
        menu: user.menus.first,
        recipe: Recipe.offset(rand(Recipe.count)).first
      )
    end
    50.times do
      FactoryGirl.create(
        :menu_item,
        menu: user.menus.last,
        recipe: Recipe.offset(rand(Recipe.count)).first
      )
    end

    puts 'Create several for_self recipes for Wangsan'.green
    10.times { FactoryGirl.create(:recipe, user: user) }

    puts 'MowData done!'.green
  end
end
