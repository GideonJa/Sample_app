class Micropost < ActiveRecord::Base
   attr_accessible :content
   belongs_to :user
  
   default_scope :order => 'microposts.created_at DESC'
   
   validates :content,    :presence => true,
                          :length => {:maximum => 140}
   validates :user_id,    :presence => true

scope :from_followed_by, lambda {|user| followed_by(user) }

private

def self.followed_by(user)
  following_ids =  %(SELECT followed_id FROM relationships 
                      WHERE follower_id = :user_id)

  where("user_id IN  (#{following_ids}) OR user_id = :user_id", 
                      {:user_id => user})  
end


# def self.from_followed_by(user)
#   following_ids2 = user.following_ids.join(", ")
#   where("user_id IN  (#{following_ids2}) OR user_id = ?", user)  
# end

end
