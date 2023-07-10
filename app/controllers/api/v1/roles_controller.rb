module Api
  module V1
    class RolesController < ApplicationController
      before_action :authenticate_user!

      def index
        roles = Role.all
        render json: roles
      end
    end
  end
end