# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ListChannel < ApplicationCable::Channel
  def subscribed
    (current_user.created_lists + current_user.collaboration_lists).each do |list|
      stream_from "list:#{list.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
