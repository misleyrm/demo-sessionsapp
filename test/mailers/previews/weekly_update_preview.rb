# Preview all emails at http://localhost:3000/rails/mailers/weekly_update
class WeeklyUpdatePreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/weekly_update/wips
  def wips
    WeeklyUpdate.wips
  end

  # Preview this email at http://localhost:3000/rails/mailers/weekly_update/completeds
  def completeds
    WeeklyUpdate.completeds
  end

  # Preview this email at http://localhost:3000/rails/mailers/weekly_update/blockers
  def blockers
    WeeklyUpdate.blockers
  end

end
