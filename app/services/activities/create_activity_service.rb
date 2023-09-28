module Activities
  class CreateActivityService
    def initialize(activity_params)
      @activity_params = activity_params
    end

    def call
      activity = Activity.new(@activity_params)

      if activity.save
        { success: true, activity: activity }
      else
        { success: false, errors: activity.errors }
      end
    end


  end
end