class UserMailer < ApplicationMailer
  default from: 'acotb.unbosque@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenido a nuestra aplicación')
  end

  def reset_password(user)
    @user = user
    @reset_password_url = edit_user_password_path(reset_password_token: @user.reset_password_token)
    mail(to: @user.email, subject: "Instrucciones para restablecer tu contraseña")
  end

end
