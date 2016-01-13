class OrganizationsController < ApplicationController
  before_action :admin_only, only: :index

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  private

  def admin_only
    redirect_to root_path and return unless current_user && current_user.admin?
  end
end
