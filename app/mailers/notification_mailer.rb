class NotificationMailer < ApplicationMailer
  def debt_milestone(user, debt, milestone)
    @user = user
    @debt = debt
    @milestone = milestone
    mail(to: user.email, subject: "🎯 Debt Milestone: #{milestone}")
  end

  def market_alert(user, security, trigger)
    @user = user
    @security = security
    @trigger = trigger
    mail(to: user.email, subject: "📈 Market Alert: #{security.ticker}")
  end

  def sip_reminder(user, sip)
    @user = user
    @sip = sip
    mail(to: user.email, subject: "💼 SIP Reminder: #{sip.name}")
  end

  def weekly_digest(user, stats)
    @user = user
    @stats = stats
    mail(to: user.email, subject: "📊 Your Weekly Kubera Digest")
  end
end
