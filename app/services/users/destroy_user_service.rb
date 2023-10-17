module Users
  class DestroyUserService
    include ActiveModel::Validations
    attr_accessor :id, :user, :user_profile

    def initialize(id:)
      @id = id
      @user = User.find(id)
      @user_profile = user.user_profile
    end

    def call
      ActiveRecord::Base.transaction do
        if destroy_resources
          user.user_profile.destroy!
          user.destroy!
        end
      end
      self
    end

    private

    def destroy_resources
      if user_profile.has_role? :student
        destroy_student_entities(user_profile.student)
        user_profile.student.destroy!
        user_profile.remove_role :student
        return true
      end

      if user_profile.has_role? :manager
        if can_manager_be_destroyed?(user_profile.manager)
          user_profile.manager.destroy!
          user_profile.remove_role :manager
          return true
        else
          errors.add(:user, 'is a manager with active rotations')
          return false
        end
      end

      if user_profile.has_role? :professor
        if can_professor_be_destroyed?(user_profile.professor)
          user_profile.professor.destroy!
          user_profile.remove_role :professor
          return true
        else
          errors.add(:user, 'is a professor with active subjects')
          return false
        end
      end

      if user_profile.has_role? :superadmin
        user_profile.remove_role :superadmin
        return true
      end
    end

    def destroy_student_entities(student)
      activity_califications = student.activity_califications
      activity_califications.each { |activity_calification| activity_calification.bloom_taxonomy_levels.destroy_all if activity_calification.bloom_taxonomy_levels.present?}
      activity_califications.destroy_all
      student_informations = student.student_informations
      student_informations.destroy_all
    end

    def can_manager_be_destroyed?(manager)
      rotations = Rotation.where(manager_id: manager.id)
      return !rotations.present?
    end

    def can_professor_be_destroyed?(professor)
      subjects = Subject.where(professor_id: professor.id)
      return !subjects.present?
    end
  end
end