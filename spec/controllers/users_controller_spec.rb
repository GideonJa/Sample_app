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
  end # describe "GET 'new'" do
  
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
  end # describe "GET 'show'" do

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
        
        it "should sign the user in" do
            post :create, :user => @attr
            controller.should be_signed_in
        end
    end # describe "success" do
  end # POST create
  
  describe "GET 'edit'" do
     before(:each) do
         @user = Factory(:user)
         test_sign_in(@user)
       end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should find the right user" do
         get :edit, :id => @user.id
        assigns(:user).should == @user
      end

      it "should hav the right title" do
         get :edit, :id => @user.id
         response.should have_selector("title", :content => "Update")
     end
     
     it "should have a link to change the Gravatar" do
         get :edit, :id => @user.id
         gravatar_url = "http://gravatar.com/emails"
         response.should have_selector("a", :href => gravatar_url,
                                            :content => "Change")
     end
  end # describe "GET 'edit'" do
   
  describe "PUT 'update'" do
     before(:each) do
       @user = Factory(:user)
       test_sign_in(@user)
     end
     describe "failure" do
        before(:each) do
          @attr = {:name => "Gideon Jadlovker", 
                  :email => "",
                  :password => "",
                  :password_confirmation => ""}
        end

        it "should have the right title" do
            put :update, :id => @user, :user => @attr
            response.should have_selector("title", :content =>  "User Update")
        end #"should hav the right title"

        it "should render the 'edit' page" do
             put :update, :id => @user, :user => @attr
             response.should render_template('edit')
         end 
     end # failure

     describe "success" do
        before(:each) do
            @attr = {:name => "Gideon Jadlovker", 
                    :email => "new@example.com",
                    :password => "foobar",
                    :password_confirmation =>  "foobar"}
        end

        it "should change the user's attributes" do
            put :update, :id => @user, :user => @attr
            @user.reload
            @user.name.should   == @attr[:name]
            @user.email         == @attr[:email]
         end

         it "should redirect to the user show page" do
             put :update, :id => @user, :user => @attr
             response.should redirect_to(user_path(@user))
         end

         it "should have a correct message" do
             put :update, :id => @user, :user => @attr
             flash[:success].should =~ /updated/i
         end
     end # describe "success" do
   end # PUT update

  describe "Authentication of edit/update users" do
      before(:each) do
            @user = Factory(:user)
          end

  describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
      end
  end #  describe "for non-signed-in users" do
  
  describe "for signed-in users" do
        before(:each) do
            wrong_user = Factory(:user, :email => "user@example.net")
            test_sign_in(wrong_user)
          end
          
      it "should deny access to 'edit' unless matching user" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
      end

      it "should deny access to 'update' unless matching user" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
      end
  end #  describe "for signed-in users" do
  end # describe "Authentication of edit/update users" do
  
 #========================================================================
  describe "GET index" do
    describe "for non-signed-in users" do
        it "should deny access to 'index'" do
            get :index
            response.should redirect_to(signin_path)
        end
    end #  describe "for non-signed-in users" do
    
    describe "for signed-in users" do
        before(:each) do
              @user = test_sign_in(Factory(:user))
              second = Factory(:user, :name => "Bob", :email => "another@example.com")
              third  = Factory(:user, :name => "Ben", :email => "another@example.net")
              @users = [@user, second, third]
            end

            it "should be successful" do
              get :index
              response.should be_success
            end

            it "should have the right title" do
              get :index
              response.should have_selector("title", :content => "All Users")
            end

            it "should have an element for each user" do
              get :index
              @users.each do |user|
                response.should have_selector("td", :content => user.name)
              end
            end
    end #  describe "for signed-in users" do
  end
end
