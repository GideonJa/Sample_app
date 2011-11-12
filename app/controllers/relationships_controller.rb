class RelationshipsController < ApplicationController
   before_filter :validate_login
   
  def create
    @followed =User.find_by_id(params[:relationship][:followed_id])
    current_user.follow!(@followed)
    redirect_to @followed
  end

  def destroy
    @unfollowed = Relationship.find(params[:id]).followed
    current_user.unfollow!(@unfollowed)
    redirect_to @unfollowed
  end

end
