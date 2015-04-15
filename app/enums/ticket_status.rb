class TicketStatus < ClassyEnum::Base
end

class TicketStatus::Unsold < TicketStatus
end

class TicketStatus::Sold < TicketStatus
end

class TicketStatus::LockedForPurchase < TicketStatus
end

class TicketStatus::LockedByEventOwner < TicketStatus
end
