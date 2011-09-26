class WelcomesController < ApplicationController

  def index
    @groups = Group.all
  end

end
