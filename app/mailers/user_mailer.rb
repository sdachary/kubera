class UserMailer < ApplicationMailer
  def password_reset(user, token)
    @user = user
    @token = token
    @reset_url = edit_password_reset_url(token: token)
    mail to: user.email, subject: "Reset your Kubera password"
  end
end
