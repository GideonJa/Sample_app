Factory.define :user do |user|
  user.name                  "Gideon J"
  user.email                 "gideonj1@gmail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end