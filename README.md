TICKET WIN - MVP

User Stories

All users have ability to create events, once created they have sole access to edit / destroy that event

Guests
Any visitor to the website that’s not logged in

Users

Buy tickets and browse events (location, type, category, time) 
Look up / access / print tickets by user email + login

Owners

User becomes owner when they create a new event 

Resources / Roles -- Users / Events / Tickets / VIP Tickets

Admin - Thomas - Cameron - Kyle
Approve events before published - Edit / Destroy
See ticket sales
Set ticket fees (10%)
Set per event ticket limit (5,000) - Any combo of REG + VIP

Users 
attributes: email + password + zip + ( maybe - image/gravatar/avatar)

associations:
user: has many tickets 
user/owner: has many events / has many tickets

Event has many tickets / has many users
Events (add paperclip to events for promo graphics)
Attributes: 
~~Title~~
~~Description~~ 
~~Date~~
Image (paperclip gem) 
Event Status ( Pending approval Live, Expired ) 
~~REG ticket quantity + price~~ (handled by tickets)
~~VIP ticket quantity + price~~ (handled by tickets)

Tickets 
associations: belongs to user / belongs to event 
attributes: 
Ticket_id 
SKU(event_id + random #) 
user_id 
user_email
event_id 


VIP_Tickets 
associations: belongs to user / belongs to event 
Ticket_id 
SKU(event_id + random #) 
user_id 
user_email
event_id 


## To do

* Create event model

    ATTRIBUTES: name, location, start_datetime, duration, description, image,
    owner, tickets, 

* Enforce SSL encryption
* Implement Stripe checkout
