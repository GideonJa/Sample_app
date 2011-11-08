namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end # :populate => :environment do
end # namespace

def make_users
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
end # make_users

def make_microposts
  @user = User.all(:limit => 5)
  @user.each do |user|
    50.times do |mp|
       micro = Faker::Lorem.sentences(2).join(" ")
       user.microposts.create!(:content => micro)
     end # 50.times
   end #@user.each
end # make_microposts

def make_relationships
   users = User.all(:limit => 51)
   user = users.first
   following = users[1..50]
   followers = users[3..35]
   following.each { |followed| user.follow!(followed)}
   followers.each { |follower| follower.follow!(user)}
end
     
