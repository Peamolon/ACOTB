class UserMailer < ApplicationMailer
  default from: 'your_email@example.com' # Reemplaza con el correo electrónico desde el cual enviarás los correos

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenido a nuestra aplicación') # Puedes cambiar el asunto según tus necesidades
  end
end
