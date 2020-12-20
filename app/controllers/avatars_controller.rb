class AvatarsController < ApplicationController
  def remove_avatar
    current_user.avatar.purge
    redirect_back(fallback_location: home_path)
  end
end
