# frozen_string_literal: true
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private
  def respond_with(resource, options={})
    user_profile = current_user.user_profile
    data = {}

    data[:student_id] = user_profile.student.id if user_profile.student.present?
    data[:professor_id] = user_profile.professor.id if user_profile.professor.present?
    data[:director_id] = user_profile.director.id if user_profile.director.present?
    data[:manager_id] = user_profile.manager.id if user_profile.manager.present?

    render json: {
      status: {
        code: 200, message: 'User signed in successfully',
        data: {
          user: user_profile,
          role: current_user.user_profile.roles.last.name,
          entity: data
        }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers["Authorization"].split(' ')[1],
                             Rails.application.credentials.fetch(:secret_key_base)).first

    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200, message: 'Signed out successfully'
      }, status: :ok
    else
      render json: {
        status: 401, message: 'User has not active session'
      }, status: :unauthorized
    end
  end

end
