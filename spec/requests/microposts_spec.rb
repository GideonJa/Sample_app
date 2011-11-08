require 'spec_helper'

describe "Microposts" do
  before (:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password,  :with => user.password
    click_button
  end
  
  describe "Creation" do
    describe "failure" do
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end # failure
    
    describe "success" do
      it "should make a new micropost" do
        content = "Foo Bar"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should render_template('pages/home')
          response.should have_selector("td", :content => content)
          response.should have_selector("div.sidebar")
          response.should have_selector("th", :content => "Posts")
        end.should change(Micropost, :count).by(1)
      end
    end # success

  end # Creation
end # "Microposts"

