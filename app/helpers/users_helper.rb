module UsersHelper
  def gravatar_for(user, option = {:size => 50})
  gravatar_image_tag(user.email.downcase, :alt => user.name,
                                         :class => "gravatar",
                                         :gravatar => option)
 end
end
