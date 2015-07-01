class Log < ActiveRecord::Base
  after_create :log_verbosely

  private

  def log_verbosely
    Rails.logger.info "*** NEW EVENT ON #{self.object}: #{self.attributes}\n"
  end
end
