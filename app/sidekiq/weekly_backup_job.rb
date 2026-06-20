class WeeklyBackupJob
  include Sidekiq::Job

  def perform
    User.where.not(refresh_token: nil).find_each do |user|
      GoogleSheetBackupJob.perform_async(user.id)
    end
  end
end
