# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  runTicketCalcs()
  $('.affects-total').bind 'change paste keyup', runTicketCalcs

runTicketCalcs = ->
  $('.tier-total').each ->
    # calculate price total per row
    noTickets = $(this).parents('tr').find('.affects-total').slice(0).val()
    ticketPrice = $(this).parents('tr').find('.affects-total').slice(1).val()
    total = parseInt(ticketPrice) * parseInt(noTickets)
    total = 0 if isNaN(total)
    $(this).html("$" + total + ".00")

    # calculate table footer row
    table = $(this).parents('table')

    tierSum = table.find('pre.tier').length
    table.find('tfoot .tiers').html(tierSum + " tiers")

    tickets = 0
    table.find('.tier-ticket').each ->
      tickets = tickets + parseInt( $(this).val() )
    table.find('tfoot .tickets').html(tickets + " tickets")

    totals = 0
    table.find('td.tier-total').each ->
      totals = totals + parseInt( $(this).val() )
    table.find('tfoot .totals').html("$" + totals + ".00")

@addTierRow = ->
  $('#ticket-matrix tbody tr').last().clone(true).appendTo('#ticket-matrix tbody')
  newRow = $('#ticket-matrix tbody tr').last()

  newRow.find(':input').val('')
  tierIndex = $('#ticket-matrix tbody tr').length - 1
  newRow.find('.tier').html(tierIndex)
  newRow.find('.tier-ticket').val(1)
  newRow.find('.tier-price').val(0)
  newRow.find('.remove-row').html("<a onclick='removeTierRow("+tierIndex+")' class='btn btn-danger'><i class='fa fa-trash-o'></i></a>")

  runTicketCalcs()

@removeTierRow = (index) ->
  i = index
  $('#ticket-matrix tbody tr').eq(i).remove()
  $('#ticket-matrix tbody tr').slice(i).each ->
    $(this).find('.tier').html(i)
    i = i + 1
  runTicketCalcs()
