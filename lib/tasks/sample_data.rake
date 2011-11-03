namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Gideon Jadlovker",
                 :email => "gideonj1@gmail.com",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@example.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end # 99.times
    @user = User.all(:limit => 5)
    @user.each do |user|
      50.times do |mp|
         micro = Faker::Lorem.sentences(2).join(" ")
         user.microposts.create!(:content => micro)
       end # 50.times
     end #@user.each
  end # :populate => :environment do
end # namespace
