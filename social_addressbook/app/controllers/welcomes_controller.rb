class WelcomesController < ApplicationController
  before_filter :authenticate_user!
  def index
    @groups = Group.all
  end

end
