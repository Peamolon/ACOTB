class UserMailer < ApplicationMailer
  default from: 'acotb.unbosque@gmail.com'

  def welcome_email(user)
    @user = user
    @change_password_url = edit_user_password_url(user, reset_password_token: user.reset_password_token)
    mail(to: user.email, subject: "Bienvenido a ACOTB")
  end

  def reset_password(user)
    @user = user
    @reset_password_url = edit_user_password_url(reset_password_token: @user.reset_password_token)
    mail(to: @user.email, subject: "Instrucciones para restablecer tu contraseña")
  end

end
