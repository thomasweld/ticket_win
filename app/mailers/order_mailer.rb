class OrderMailer < ApplicationMailer
  add_template_helper(EmailHelper)
  default from: "TicketWin <#{ENV['SENDER_EMAIL']}>"

  def order_confirmation_email(order)
    @order = order
    @email = @order.delivery_email

    mail to: @email, bcc: ENV['SENDER_EMAIL'], subject: "Ticket delivery for #{@order.event.title} on #{@order.event.start_date.to_formatted_s(:short)}"
  end
end
