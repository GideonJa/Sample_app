require 'spec_helper'

describe User do
  before(:each) do
     @attr = {:name => "Gideon Jadlovker", 
              :email => "gideon@ibm.net",
              :password => "foobar",
              :password_confirmation => "foobar"}
  end
  
  it "should create a new record given valid attributes" do
    user = User.create!(@attr)
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
    
  # password validation
  describe "password validations" do
    
    it "should require a password" do
      user_with_no_pass = User.new(@attr.merge(:password=>""))
      user_with_no_pass.should_not  be_valid
    end
    
    it "should require a password to mach pass confirmation" do
      user_with_unmatched_pass = 
      User.new(@attr.merge(:password_confirmation=> "invalid"))
      user_with_unmatched_pass.should_not  be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      user_with_short_pass = 
      User.new(@attr.merge(:password=> short, :password_confirmation=> short))
       user_with_short_pass.should_not  be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 21
      user_with_long_pass = 
      User.new(@attr.merge(:password=> long, :password_confirmation=> long))
       user_with_long_pass.should_not  be_valid
    end
    end  # password validation
 
    # password encryption
    describe "password encryption" do 
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should have an encrypted password attribute" do
            @user.should respond_to(:encrypted_password)
      end
    
      it "should have a non blank encrypted password field" do
        @user.encrypted_password.should_not be_blank
    end
    
      it "return true if password match" do
        @user.has_password?(@attr[:password]).should be_true
    end
  
        # authenticate method
        describe "authenticate method" do
          it "should return nil given unknown email" do
              unknown_user = User.authenticate("invalid", @attr[:password])
              unknown_user.should be_nil
           end
   
        it "should return nil given incorrect password" do
        invalid_pass = User.authenticate(@attr[:email], "invalid")
        invalid_pass.should be_nil
       end  
      end  # authenticate method
    end  # password encryption

  describe "admin attribute" do
    before(:each) do
          @user = User.create!(@attr)
        end
        
    it "should have an admin attribute" do
          @user.should respond_to(:admin)
    end
    
    it "should not be admin by default" do
          @user.should_not be_admin
    end
    it "respond to toggle" do
        @user.toggle(:admin)
        @user.should be_admin
    end
  end # "admin attribute"
  
end #user