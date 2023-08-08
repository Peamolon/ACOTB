module Users
  class DestroyUserService
    attr_accessor :id, :user, :user_profile

    def initialize(id:)
      @id = id
      @user = User.find(id)
      @user_profile = user.user_profile
    end

    def call
      ActiveRecord::Base.transaction do
        destroy_resources
        user.user_profile.destroy!
        user.destroy!
      end
    end

    private

    def destroy_resources
      if user_profile.has_role? :student
        user_profile.student.destroy!
        user_profile.remove_role :student
      end

      if user_profile.has_role? :director
        user_profile.director.destroy!
        user_profile.remove_role :director
      end

      if user_profile.has_role? :manager
        user_profile.manager.destroy!
        user_profile.remove_role :manager
      end

      if user_profile.has_role? :professor
        user_profile.professor.destroy!
        user_profile.remove_role :professor
      end

      if user_profile.has_role? :administrator
        user_profile.administrator.destroy!
        user_profile.remove_role :administrator
      end
    end
  end
end