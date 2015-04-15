class EventStatus < ClassyEnum::Base
end

class EventStatus::PendingApproval < EventStatus
end

class EventStatus::Live < EventStatus
end

class EventStatus::Expired < EventStatus
end
