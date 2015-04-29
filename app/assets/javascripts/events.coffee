$ ->
  runTicketCalcs()
  $('.affects-total').bind 'change paste keyup', runTicketCalcs
  @formatPricingFeatures(false)

@formatPricingFeatures = (option) ->
  if option
    optionClass = '.pricing-priced'
    flipClass = '.pricing-free'
  else
    optionClass = '.pricing-free'
    flipClass = '.pricing-priced'

  $('.btn'+optionClass).removeClass('btn-invert').addClass('btn-info')
  $('.btn'+flipClass).removeClass('btn-info').addClass('btn-invert')

  $('.tier-price').attr('disabled', !option)
  $('#payments-jumbo').children().attr('disabled', !option)
  opacity = if option then 1 else 0.10
  skipO = if option then 0 else 1
  $('#payments-jumbo').children().fadeTo(1000, opacity)
  $('.small.pricing-free').fadeTo(250, skipO)

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
    table.find('td.tier-total').each ->
      totals = totals + parseInt( $(this).val() )
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
