require 'spec_helper'

describe MicropostsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  # describe "GET 'destroy'" do
  #     it "should be successful" do
  #       delete :destroy
  #       response.should be_success
  #     end
  #   end

end
