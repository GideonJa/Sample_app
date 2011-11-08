require 'spec_helper'

describe Relationship do
  before(:each) do
      @follower = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
      @attr = {:followed_id => @followed.id}
      @relationship = @follower.relationships.build(@attr)
   end

   it "should create a new instance given valid attributes" do
     @follower.relationships.create!(@attr)
   end
   
   it "should require a followed_id field" do
     invalid = @follower.relationships.build
     invalid.should_not  be_valid
   end
   
    it "should require a follower_id field" do
      empty_id = Relationship.new(@attr)
      empty_id.should_not  be_valid
    end

    describe "follow methods associations" do
      before(:each) do
            @relationship.save
      end

     it "should have a follower attribute" do
        @relationship.should respond_to(:follower)
     end

     it "should have the right follower" do
        @relationship.follower.should == @follower
     end
     it "should have a followed attribute" do
        @relationship.should respond_to(:followed)
     end

     it "should have the right followed" do
        @relationship.followed.should == @followed
     end
     
   end# follow methods
end
