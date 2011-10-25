require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should hav the right title" do
      get :new
      response.should have_selector("title", :content =>  "Sign In")
    end
  end #describe "GET 'new'" do

  describe "POST 'create'" do
    describe "invalid signin" do
      
       before(:each) do
            @attr = { :email => "email@example.com",
                      :password => "invalid"}
       end
       
       it "should have a flash.now message" do
         post :create, :session => @attr
         flash.now[:error].should =~ /invalid/i
       end
       
       it "should hav the right title" do
           post :create, :session => @attr
           response.should have_selector("title", :content =>  "Sign In")
       end #"should hav the right title"
       
       it "should render the 'new' page" do
            post :create, :session => @attr
            response.should render_template('new')
        end #"should render the 'new' page"
    end # "invalid signin"
  
  describe "Sign in with valid email and password" do
    before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      
       # it "should have the right title" do
       #            post :create, :session => @attr
       #            response.should have_selector("title", :content =>  @user.name)
       #        end
       
       it "should sign the user in" do
           post :create, :session => @attr
           controller.current_user.should == @user
           controller.should be_signed_in
       end
      
       it "should redirect to the user show page" do
            post :create, :session => @attr
            response.should redirect_to(user_path(@user))
        end
    end # "Sign in with valid email and password"
  end #"POST 'create'" do
  
  describe "DELETE destroy" do
    
    it "should sign a user out" do
        test_sign_in(Factory(:user))
        delete :destroy
        controller.should_not be_signed_in
        response.should redirect_to(root_path)
    end      
  end #Delete
end
