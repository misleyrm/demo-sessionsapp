class ListRelayJob < ApplicationJob
  queue_as :default

  def perform(list,data)

    if (data["status"]== "created")
      list = List.find(data["id"])
      user = list.owner
      html= render_list_li(list,user,true)
      
      ActionCable.server.broadcast "list_channel", {
        data: data,
        html: html
      }
    end

  end

  def render_list_li(list,user,active)
     ListsController.render(partial: "lists/nav_list_name",  layout: "layouts/li_navigation", locals: {"list": list, "user": user, "active": active}).squish
  end
end
