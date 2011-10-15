require 'spec_helper'

describe User do
  before(:each) do
     @attr = {:name => "Gideon Jadlovker", :email => "gideon@ibm.net"}
   end
  
  it "should create a new record givven valid attributes" do
    user = User.new(@attr)
  end
  
  it "should require a name field" do
    user_with_no_name = User.new(@attr.merge(:name=>""))
    user_with_no_name.should_not  be_valid
  end
  
  it "should require an email field" do
    user_with_no_email = User.new(@attr.merge(:email=>""))
    user_with_no_email.should_not  be_valid
  end
  
  it "should require name field to max @ 50" do
    long_name = "a" * 51
    user_with_long_name = User.new(@attr.merge(:name=>long_name))
    user_with_long_name.should_not  be_valid
  end
  
  it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |addr|
          user = User.new(@attr.merge(:email => addr))
          user.should_not be_valid
      end
  end
    
    it "should not accept duplicate email addresses" do
      User.create!(@attr)
      user_with_dup_email = User.new(@attr)
      user_with_dup_email.should_not  be_valid
    end
    
    it "should not accept duplicate email addresses up to case" do
      upper_case_email=@attr[:email].upcase
      User.create!(@attr)
      user_with_dup_email = User.new(@attr.merge(:email => upper_case_email))
      user_with_dup_email.should_not  be_valid
    end
end
