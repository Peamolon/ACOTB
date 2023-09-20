class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def create
    user = User.where('email = (?)', params[:email]).first
    if user.present?
      mail = user.try(:send_reset_password_instructions)
      if mail.present?
        render json: {
          status: { code: 200, message: 'Send instructions for reset password'}
        }, status: :ok
      else
        render json: {
          status: { message: "Don't send instructions for reset password",
                    status: :unprocessable_entity }
        }
      end
    else
      render json: {
        status: { code: 400, message: "Don't send instructions because this email don't exist",
                  status: :ok }
      }
    end
  end

  def edit
    super
  end

  def update
    self.resource = resource_class.reset_password_by_token({ reset_password_token: params[:reset_password_token],
                                                             password: params[:password],
                                                             password_confirmation: params[:password_confirmation]
                                                           })

    if resource.errors.empty?
      sign_in(resource_name, resource)
      render json: {code: 200, message: 'Update password successfully' }, status: :ok
    else
      render json: { error: resource.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

end