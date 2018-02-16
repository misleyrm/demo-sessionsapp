class NotificationSettingsController < ApplicationController
  include ApplicationHelper
  include LoginHelper
  # before_action :require_logged_in
  before_action :set_notification_setting, only: [ :update ]

  def update

    # @notification_setting.update_attributes(:ative => )
    # if saved
    #   flash[:notice] = "Setting was successfully updated."
    #
    #   respond_to do |format|
    #     format.json { }
    #     format.js { }  # render :action => "edit"
    #    end
    #
    # end
     @notification_setting.toggle! :active
     respond_to do |format|
         format.json { }
         format.js { }  # render :action => "edit"
      end
  end

  def index
    @notification_settings = User.find(2).notification_settings

    @notification = current_user.notification_setting_texts

  end

 private
   def set_notification_setting
      @notification_setting = NotificationSetting.find(params[:id])
   end

   def notification_setting_params
      params.require(:notification_setting).permit(:active, :user_id, :notification_option_id, :notification_type_id)
   end
end
