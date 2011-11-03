require 'spec_helper'

describe Micropost do
  before(:each) do
      @attr = {:content => "Lovely day"}
      @user = Factory(:user)
   end

   it "should create a new instance given valid attributes" do
     @user.microposts.create!(@attr)
   end
   
   it "should require a content field" do
     empty_micro =@user.microposts.build(:content=>"")
     empty_micro.should_not  be_valid
   end
   
    it "should require a User_id field" do
      empty_id = Micropost.new(@attr)
      empty_id.should_not  be_valid
    end
    
   it "should require content field to max @ 140" do
       @user.microposts.build(:content=> "a" * 141).should_not  be_valid
   end
  
  describe "user associations" do
      before(:each) do
            @micropost = @user.microposts.create(@attr)
          end

          it "should have a user attribute" do
            @micropost.should respond_to(:user)
          end

          it "should have the right associated user" do
            @micropost.user_id.should == @user.id
            @micropost.user.should == @user
          end
  end # describe "user associations"
  
end
