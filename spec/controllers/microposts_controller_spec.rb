require 'spec_helper'

describe MicropostsController do
  
  describe "POST 'create'" do
    describe "for signed out users" do
       it "should be NOT successful" do
         post :create
         response.should_not be_success
       end
       
       it "should redirect to 'signin' page" do
          post :create
          response.should redirect_to(signin_path)
       end
    end # "for signed out users"
    
    describe "for signed in users" do
      describe "failure" do
       before(:each) do
          @user = Factory(:user)
          @attr =  {:content => ""}
          test_sign_in(@user)
       end
      
       it "should render the 'pages/home' page" do
          post :create, :micropost=>@attr
          response.should render_template('pages/home')
       end
       
       it "should not create a user" do
           lambda do
             post :create, :micropost => @attr
             end.should_not change(Micropost, :count)
       end      
      end # Failure
      
      describe "success" do
       before(:each) do
          @user = Factory(:user)
          @attr =  {:content => "Foo Bar"}
          # @attr = Factory(:micropost, :user => @user)
          test_sign_in(@user)
       end

       it "should render the 'pages/home' page" do
          post :create, :micropost=>@attr
          #response.should render_template('pages/home')
          response.should redirect_to(root_path)
       end
       
       it "should create a user" do
          lambda do
            post :create, :micropost => @attr
          end.should change(Micropost, :count).by(1) 
       end
       
       it "should have a confirmation flash" do
             post :create, :micropost => @attr
             flash[:success].should =~ /created successfully/i
       end           
      end # Success
    end # "for signed in users"
  end # "POST 'create'"

  describe "delete destroy" do
    describe "for signed out users" do
       
       it "should redirect to 'signin' page" do
         delete :destroy, :id => 1
         response.should redirect_to(signin_path)
       end
    end # signed out
  end # "delete destroy"
 end
