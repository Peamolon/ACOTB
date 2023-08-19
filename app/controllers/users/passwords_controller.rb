class Users::PasswordsController < Devise::RegistrationsController
  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def respond_with(options={})
    user = User.find_by(email: params[:email])
    if user.present?
      UserMailer.reset_password(user).deliver_now
      render json: {
        status: { code: 200, message: 'Send instructions'}
      }, status: :ok
    else
      render json: {
        status: { message: "Don't send instructions because this email don't exist",
                  status: :unprocessable_entity }
      }
    end
  end

end