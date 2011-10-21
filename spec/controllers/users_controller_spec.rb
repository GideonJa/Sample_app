require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should hav the right title" do
      get :new
      response.should have_selector("title", :content =>  "Sign up")
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
        @user = Factory(:user)
      end
      
     it "should be successful" do
       get :show, :id => @user
       response.should be_success
     end

     it "should find the right user" do
        get :show, :id => @user.id
       assigns(:user).should == @user
     end
     
     it "should hav the right title" do
        get :show, :id => @user.id
        response.should have_selector("title", :content =>  @user.name)
    end
    
    it "should hav the right h1" do
        get :show, :id => @user.id
        response.should have_selector("h1", :content =>  @user.name)
    end
    
    it "should hav the right profile image" do
        get :show, :id => @user
        response.should have_selector("h1>img", :class =>  "gravatar")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
       before(:each) do
            @attr = {:name => "Gideon Jadlovker", 
                      :email => "",
                      :password => "",
                      :password_confirmation => ""}
       end # before each
       it "should not create a user" do
         lambda do
           post :create, :user => @attr
           end.should_not change(User, :count)
       end # "should not create a user"
       
       it "should hav the right title" do
           post :create, :user => @attr
           response.should have_selector("title", :content =>  "Sign up")
       end #"should hav the right title"
       it "should render the 'new' page" do
            post :create, :user => @attr
            response.should render_template('new')
        end #"should render the 'new' page"
    end # failure
    describe "success" do
      before(:each) do
            @attr = {:name => "Gideon Jadlovker", 
                      :email => "user@example.com",
                      :password => "foobar",
                      :password_confirmation => "foobar"}
       end # before each
       
       it "should create a user" do
          lambda do
            post :create, :user => @attr
            end.should change(User, :count).by(1)
        end # "should create a user"
        
        it "should redirect to the user show page" do
            post :create, :user => @attr
            response.should redirect_to(user_path(assigns(:user)))
        end # it "should redirect to the user show page" do
        it "should have a welcome message" do
               post :create, :user => @attr
               flash[:success].should =~ /welcome to the sample app/i
             end #  it "should have a welcome message" do
    end # describe "success" do
  end # POST create
end
