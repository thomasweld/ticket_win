$ ->
  $('form.require-validation').bind 'submit', (e) ->
    unless gon.freeOrder
      $form = $(e.target).closest('form')
      inputSelector = [
        'input[type=email]'
        'input[type=password]'
        'input[type=text]'
        'input[type=file]'
        'textarea'
      ].join(', ')
      $inputs = $form.find('.required').find(inputSelector)
      $errorMessage = $form.find('div.error')
      valid = true
      $errorMessage.addClass 'hide'
      $('.has-error').removeClass 'has-error'
      $inputs.each (i, el) ->
        $input = $(el)
        if $input.val() == ''
          $input.parent().addClass 'has-error'
          $errorMessage.removeClass 'hide'
          e.preventDefault()
          # cancel on first error

$ ->
  $form = $('.payment-form')

  stripeResponseHandler = (status, response) ->
    if response.error
      $('.error').removeClass('hide').find('.alert').text response.error.message
      $form.find('.btn').attr('disabled', false)
    else
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      $form.find('input[type=text]').empty()
      $form.append "<input type='hidden' name='stripe_token' value='" + token + "'/>"
      $form.get(0).submit()

  $form.on 'submit', (e) ->
    unless gon.freeOrder
      e.preventDefault()
      $form.find('.btn').attr('disabled', true)
      Stripe.setPublishableKey gon.stripePubKey
      Stripe.createToken {
        number: $('.card-number').val()
        cvc: $('.card-cvc').val()
        exp_month: $('.card-expiry-month').val()
        exp_year: $('.card-expiry-year').val()
      }, stripeResponseHandler
