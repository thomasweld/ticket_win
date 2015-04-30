class StripeController < ApplicationController

  def connect
    redirect_to StripeOauth.new(current_user).oauth_url
  end

  def confirm
    if params[:code]
      StripeOauth.new(current_user).verify!(params[:code])
    elsif params[:error]
      params[:error_description]
    end
  end
end
