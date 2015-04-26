class HostsController < ApplicationController

  def new
    @host = Host.new
    @email = current_user.email
  end

  def disable
    redirect_to toggle_host(:disable)
  end

  def enable
    redirect_to toggle_host(:enable)
  end

  private

  def toggle_host(action)
    current_user.update_attribute(:host_enabled, action == :enable ? true : false)
    session.delete(:return_to) || :back
  end
end
