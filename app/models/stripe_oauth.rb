class StripeOauth

  def initialize(user)
    @user = user
  end

  def oauth_url
    client.authorize_url(response_type: 'code', scope: 'read_write')
  end

  def verify!(code)
    data = client.get_token(code, params: { scope: 'read_write' })
    @user.update_attributes(user_stripe_params(data).merge(stripe_authorized_at: Time.now))
  end

  private

  def client
    @client ||= OAuth2::Client.new(*client_params).auth_code
  end

  def client_params
    [
      ENV['STRIPE_CLIENT_ID'], ENV['STRIPE_SECRET_KEY'],
      {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }
    ]
  end

  def user_stripe_params(data)
    {
      stripe_user_id: data.params['stripe_user_id'],
      stripe_account_type: 'oauth',
      stripe_pub_key: data.params['stripe_publishable_key'],
      stripe_secret_key: data.token
    }
  end
end
