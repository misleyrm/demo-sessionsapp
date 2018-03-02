# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class TaskChannel < ApplicationCable::Channel
  def subscribed
    (current_user.created_lists + current_user.collaboration_lists).each do |list|
      stream_from "task_list_#{list.id}"
    end
    # list = List.find(params[:id])
    # stream_for list

  end

  def unsubscribed
    stop_all_streams
  end
end
