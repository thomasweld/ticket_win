$ ->
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

    table = $(this).parents('table')

    tierSum = table.find('pre.tier').length
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
  $('#ticket-matrix tbody tr').last().clone(true).appendTo('#ticket-matrix tbody')
  newRow = $('#ticket-matrix tbody tr').last()

  newRow.find(':input').val('')
  tierIndex = $('#ticket-matrix tbody tr').length - 1
  newRow.find('.tier').html(tierIndex)
  newRow.find('.tier-ticket').val(0)
  newRow.find('.tier-price').val(0)
  newRow.find('.action-col').html("<a onclick='removeTierRow(this)' class='btn btn-danger'><i class='fa fa-trash-o'></i></a>")

  if $('#ticket-matrix tbody tr').length >= 5
    $('#ticket-matrix tbody tr').first().find('.action-col').hide()

  runTicketCalcs()

@removeTierRow = (el) ->
  $(el).parents('tr').remove()
  $('#ticket-matrix tbody tr').each (i) ->
    $(this).find('.tier').html(i)
  $('#ticket-matrix tbody tr').first().find('.action-col').show()
  runTicketCalcs()
