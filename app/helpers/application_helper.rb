module ApplicationHelper
  def title
  if @title.nil?
    then "Ruby on Rails Tutorial Sample App"
    else "Ruby on Rails Tutorial Sample App | #{@title}"
  end
end

def logo
  image_tag "logo.png", :alt =>  "Tutorial Logo", :class => "round"
end
end
