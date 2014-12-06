class HomeController < ApplicationController
  def index
    @folders = current_user.folders
  end
end
