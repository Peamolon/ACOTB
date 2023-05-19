# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  private
  def respond_with(resource, options={})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully', data: resource }
      }, status: :ok
    else
      render json: {
        status: { message: 'User could not be created successfully', errors: resource.errors.full_messages,
                  status: :unprocessable_entity }
      }
    end
  end
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :telephone, :role, :email, :password, :password_confirmation, :username)
  end
end
