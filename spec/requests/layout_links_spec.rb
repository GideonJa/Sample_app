require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
      get '/about'
      response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
  end
    
  it "should have a Signup page at '/signup'" do
      get '/signup'
      response.should have_selector('title', :content => "Sign up")
  end
    
  it "should have the correct links on the main (layout) page" do
      visit root_path
      click_link "Sign up now!"
      response.should have_selector('title', :content => "Sign up")
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      click_link "Home"
      response.should have_selector('title', :content => "Home")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
  end
  describe "when not signed in" do
      it "should have a signin link" do
        visit root_path
        response.should have_selector("a", :href => signin_path,
                                           :content => "Sign In")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end

      it "should have a signout link" do
        visit root_path
        response.should have_selector("a", :href => signout_path,
                                           :content => "Sign Out")
      end

      it "should have a profile link" do
        visit root_path
        response.should have_selector("a", :href => user_path(@user),
                                           :content => "Profile")
      
      end 
    end  # "when signed in"
    
    describe "when signed in as admin" do

      before(:each) do
        @admin = Factory(:user, 
                        :email => "admin123@example.com", 
                        :admin => true)
        visit signin_path
        fill_in :email,    :with => @admin.email
        fill_in :password, :with => @admin.password
        click_button
      end

      it "should have a delete link" do
        visit users_path
        response.should have_selector("a", :href => user_path(@admin),
                                           :content => "Delete")
      
      end 
    end  # "when signed in as admin"
  end