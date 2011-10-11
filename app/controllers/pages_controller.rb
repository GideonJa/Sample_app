class PagesController < ApplicationController
  def home
    @page = "Home"
  end

  def contact
    @page = "Contact"
  end

  def about
    @page = "About"
  end

end
