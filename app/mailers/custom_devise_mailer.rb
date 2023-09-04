class CustomDeviseMailer < Devise::Mailer
  default template_path: 'devise/mailer' # to make sure that you mailer uses the devise views

  def reset_password_instructions(record, token, opts={})
    opts[:subject] = t 'devise.mailer.reset_password_instructions.subject', time: I18n.l(1.day.from_now, format: :human_short)
    super
  end

end