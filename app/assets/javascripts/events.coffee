$ ->
  @reduceTickets()
  runTicketCalcs()
  $('.affects-total').bind 'change paste keyup', runTicketCalcs
  @formatPricingFeatures(gon.stripeAuthorized || gon.stripeMessage)
  @pushStripeData(gon.stripeMessage)

@formatPricingFeatures = (option) ->
  if option
    optionClass = '.pricing-paid'
    flipClass = '.pricing-free'
  else
    optionClass = '.pricing-free'
    flipClass = '.pricing-paid'

  $('.btn'+optionClass).removeClass('btn-invert').addClass('btn-info')
  $('.btn'+flipClass).removeClass('btn-info').addClass('btn-invert')

  $('.tier-price').attr('disabled', !(option && gon.stripeAuthorized))
  $('.connect-stripe').attr('disabled', !!gon.stripeAuthorized)
  $('#payments-jumbo').children().attr('disabled', !option)
  opacity = if option then 1 else 0.10
  skipO = if option then 0 else 1
  $('#payments-jumbo').children().not('.pricing-free').fadeTo(1000, opacity)
  $('#payments-jumbo .pricing-free').fadeTo(500, skipO)

@pushStripeData = (data) ->
  $('#payments-jumbo #stripe-comm').addClass('alert alert-danger').html(data) if data

runTicketCalcs = ->
  $('.tier-total').each ->

    noTickets = $(this).parents('tr').find('.affects-total').slice(0).val()
    ticketPrice = $(this).parents('tr').find('.affects-total').slice(1).val()
    total = parseInt(ticketPrice) * parseInt(noTickets)
    total = 0 if isNaN(total)
    $(this).html("$" + total + ".00")

    $(this).parents('tr').find('.price-cents').val(ticketPrice*100)

    table = $(this).parents('table')

    tierSum = $('#ticket-matrix tbody tr:visible').length
    table.find('tfoot .tiers').html(tierSum + " tier(s)")

    tickets = 0
    table.find('.tier-ticket').each ->
      tickets = tickets + parseInt( $(this).val() )
    tickets = 0 if isNaN(tickets)
    table.find('tfoot .tickets').html(tickets + " ticket(s)")

    totals = 0
    table.find('pre.tier-total').each ->
      totals = totals + parseInt( $(this).html().slice(1) )
    totals = 0 if isNaN(totals)
    table.find('tfoot .totals').html("$" + totals + ".00")

@addTierRow = ->
  $('#ticket-matrix tbody tr:visible').next().show()

  $('#remove-tier-btn').attr('disabled', false)
  if $('#ticket-matrix tbody tr:visible').length >= 5
    $('#add-tier-btn').attr('disabled', true)

  runTicketCalcs()

@removeTierRow = () ->
  lastRow = $('#ticket-matrix tbody tr:visible').last()
  lastRow.find(':input').val('')
  lastRow.find('.tier-ticket').val(0)
  lastRow.find('.tier-price').val(0)
  lastRow.hide()

  $('#add-tier-btn').attr('disabled', false)
  if $('#ticket-matrix tbody tr:visible').length <= 1
    $('#remove-tier-btn').attr('disabled', true)

  runTicketCalcs()

@reduceTickets = () ->
  $('#ticket-matrix tbody tr').slice(1).hide()
