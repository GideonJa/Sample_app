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
  
  describe "micropost associations" do

      before(:each) do
        
        @user = User.create!(@attr)
        @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
        @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
      end

       it "should have a microposts attribute" do
        @user.should respond_to(:microposts)
       end
      
       it "should have micros in the right order" do
         @user.microposts.should == [@mp2, @mp1]
       end 
      
       it "should destroy the corresponding micros" do
         @user.destroy
         [@mp2, @mp1].each do |mp|
           del_mp = Micropost.find_by_id(mp.id)
           del_mp.should be_nil
         end
       end
      
       describe "Status feed" do

         it "should have a feed attribute" do
           @user.should respond_to(:feed)
         end

         it "should include the user's posts" do
           @user.feed.should include(@mp1)
         end
         
         it "should not include a different user's microposts" do
            mp3 = Factory(:micropost,
                  :user => Factory(:user, :email => Factory.next(:email)))
            @user.feed.include?(mp3).should be_false
         end
       end # Status feed

       describe "relationships associations" do

           before(:each) do
             @user = Factory(:user)
             @followed = Factory(:user, :email => Factory.next(:email))
           end
           
           it "should have a relationships attribute" do
            @user.should respond_to(:relationships)
           end
           
           it "should have a following attribute" do
            @user.should respond_to(:following)
           end

           it "should have a following? method" do
            @user.should respond_to(:following?)
           end
           
           it "should have a follow! method" do
            @user.should respond_to(:follow!)
           end

           it "should follow another user using follow! method" do
            @user.follow!(@followed)
            @user.following.should include(@followed)
           end
           
           it "should return true if following a @followed" do
            @user.follow!(@followed)
            @user.should be_following(@followed)
           end
           
           it "should have an unfollow! method" do
            @user.should respond_to(:unfollow!)
           end

           it "should not follow another after unfollow! method" do
            @user.follow!(@followed)
            @user.unfollow!(@followed)
            @user.following.should_not include(@followed)
           end
           
           it "should be false: following?(@followed) after unfollowed!" do
            @user.follow!(@followed)
            @user.unfollow!(@followed)
            @user.should_not be_following(@followed)
           end
#=============================================================== 
          describe " reveresed relationships" do
            before(:each) do
              @user.follow!(@followed)
            end
            
            it "should have a reverse relationships attribute" do
             @user.should respond_to(:reverse_relationships)
            end

            it "should have a followers attribute" do
             @user.should respond_to(:followers)
            end

            it "should have a followed_by? method" do
             @user.should respond_to(:followed_by?)
            end

            it "should include the follower" do
             @followed.followers.should include(@user)
            end

            it "should return true if followed by @follower" do
             @followed.should be_followed_by(@user)
            end

            it "should not have a follower after unfollow" do
              @user.unfollow!(@followed)
             @followed.followers.should_not include(@user)
             @followed.should_not be_followed_by(@user)
             end

        end # describe reverese relationships
#===============================================================           
       end  # "relationships associations"     
  end # "micropost associations" do
    
end #user