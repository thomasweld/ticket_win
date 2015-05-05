# Stripe.api_key set here will be automatically included
# in every request sent to Stripe by stripe gem

Stripe.api_key = ENV['STRIPE_SECRET_KEY']
