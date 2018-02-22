# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class InvitationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "invitation_channel:#{current_user.id}"

  end

  def unsubscribed
    stop_all_streams
  end
end
