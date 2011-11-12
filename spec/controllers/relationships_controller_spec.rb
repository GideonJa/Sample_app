require 'spec_helper'

describe RelationshipsController do

describe "POST Create" do
  describe "for signed out users" do
     it "should be NOT be successful" do
       post :create
       response.should_not be_success
     end
     
     it "should redirect to 'signin' page" do
        post :create
        response.should redirect_to(signin_path)
     end
  end # "for signed out users"
  
  describe " Signed in users" do
    before(:each) do
        @user = Factory(:user)
        @followed = Factory(:user, :email => Factory.next(:email))
        @not_followed = Factory(:user, :email => Factory.next(:email))
        test_sign_in(@user)
        @attr =  {:followed_id => @followed.id}
      
    end
        
    it "should create a new relationship" do
      lambda do
        post :create, :relationship => @attr
      end.should change(Relationship, :count).by(1)
    end
        
    it "should redirect to the show page" do
      post :create, :relationship => @attr
      response.should redirect_to(user_path(@followed))
    end

    it "should follow users in relationship" do
      post :create, :relationship => @attr
      @user.should be_following(@followed)
    end

    it "should not follow users with no relationships" do    
      post :create, :relationship => @attr
      @user.should_not be_following(@not_followed)
    end
      
  end #signed in users
  
end # POST Create



describe "DELETE Destroy" do
  describe "for signed out users" do
     it "should be NOT be successful" do
      delete :destroy, :id => 1
       response.should_not be_success
     end
     
     it "should redirect to 'signin' page" do
        delete :destroy, :id => 1
        response.should redirect_to(signin_path)
     end
  end # "for signed out users"
  
  describe " Signed in users" do
    before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @followed = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@followed)
        @relationship = @user.relationships.find_by_followed_id(@followed)
    end
    

    it "should redirect to the show page" do
      delete :destroy, :id => @relationship
      response.should redirect_to(user_path(@followed))
    end

    it "should destroy a relationship" do
      lambda do
        delete :destroy, :id => @relationship
      end.should change(Relationship, :count).by(-1)
    end
    
  end #signed in users
  
end # POST Create
end
