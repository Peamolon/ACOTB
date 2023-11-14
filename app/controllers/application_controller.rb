class ApplicationController < ActionController::API
  #protected

  #def authenticate_user!
  #  return if user_signed_in?

  #  render json: {
  #    error: 'Unauthorized'
  #  }, status: :unauthorized
  #end
  def health
    render json: { status: 'ok' }, status: :ok
  end
end
