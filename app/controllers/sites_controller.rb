class SitesController < ApplicationController
  layout "site"

  skip_before_action :authorize, :current_user

  def index

  end

  def features
  end

  def contact
  end

  def about
  end
end
