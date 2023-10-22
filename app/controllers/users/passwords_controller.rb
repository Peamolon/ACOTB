class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def create
    user = User.where('email = (?)', params[:email]).first
    if user.present?
      mail = user.try(:send_reset_password_instructions)
      if mail.present?
        render json: { message: 'Reset password instructions were sent ' } , status: :ok
      else
        render json: { message: "Something went wrong"} , status: :unprocessable_entity
      end
    else
      render json: { message: "Email not found"} , status: :not_found
    end
  end

  def edit
    super
  end

  def recovery

  end

  def update
    self.resource = resource_class.reset_password_by_token({ reset_password_token: params[:token],
                                                             password: params[:password],
                                                             password_confirmation: params[:password_confirmation]
                                                           })

    if resource.errors.empty?
      sign_in(resource_name, resource)
      render json: {code: 200, message: 'your password has been updated successfully' }, status: :ok
    else
      render json: { error: resource.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

end