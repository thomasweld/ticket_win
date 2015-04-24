class HostsController < ApplicationController

  def new
    @host = Host.new
    @email = current_user.email
  end

  def bypass
    current_user.update_attribute(:host_enabled, false)
    path = session.delete(:return_to) || :back
    redirect_to path
  end
end
