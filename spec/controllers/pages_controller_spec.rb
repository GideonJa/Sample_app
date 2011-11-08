require 'spec_helper'

describe PagesController do
 render_views
 
 before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end
 
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
        
    it "should hav the right title" do
        get 'home'
        response.should have_selector("title", :content =>  "Home")
    end

    describe "for signed OUT users" do

       it "should have a sign up link" do
        get :home
        response.should have_selector("a", :href => signup_path,
                                         :content => "Sign up now!")
       end
       
       it "should have a header" do
         get :home
         response.should have_selector("h1", :content => "Sample App")
       end
       
    end # "for signed OUT users"

    describe "for signed in users" do
       before(:each) do
            @user = Factory(:user)
            test_sign_in(@user)
       end
        
       it "should display the undelying microposts for that user" do
           mp1 = Factory(:micropost, :user => @user)
           mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
           get :home
           response.should have_selector("td", :content =>  mp1.content)
           response.should have_selector("td", :content =>  mp1.content)
       end

       it "should display a text area to input microposts" do
          get :home
          response.should have_selector("textarea")
       end
       
       it "should have a submit button" do
           get :home
           response.should have_selector("input", :type => "submit")
        end
        
        it "should have the right profile image" do
           get :home
           response.should have_selector("th>img", :class =>  "gravatar")
       end
       
       it "should have the right h1" do
          get :home
          response.should have_selector("td", :content =>  @user.name)
       end

       it "should have following" do
          @followed = Factory(:user, :email => Factory.next(:email))
          @user.follow!(@followed)
          get :home
          response.should have_selector("a", 
                                 :href => following_user_path(@user),
                                 :content =>  @user.following.count.to_s)
       end

       it "should have followers" do
          get :home
          response.should have_selector("a",
                                :href => followers_user_path(@user),
                                :content =>  @user.followers.count.to_s)
          
       end
       
    end # describe "for signed in users"
      
    
  end # GET Home
  
  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
        
    it "should hav the right title" do
      get 'contact'
      response.should have_selector("title", :content =>  "Contact")
    end
  end # "GET 'contact'" do
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
        
    it "should hav the right title" do
      get 'about'
      response.should have_selector("title", :content => "About")
    end
  end # "GET 'about'" do

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
        
    it "should hav the right title" do
      get 'help'
      response.should have_selector("title", :content =>  "Help")
    end
  end # "GET 'help'" do
end
