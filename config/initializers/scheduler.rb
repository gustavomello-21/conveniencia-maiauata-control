if Rails.env.development? || Rails.env.production?
  Thread.new do
    loop do
      sleep 30
      ExpireSessionsJob.perform_now
    rescue => e
      Rails.logger.error "Scheduler error: #{e.message}"
    end
  end
end
