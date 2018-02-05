App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $("[data-behavior='notification-items']").prepend(data.html);
    $notification = $("[data-notification-id='"+ data.id+"']")
    $("p.time").timeago();
    $("p.time", $notification ).text($.timeago(new Date(data.created_at)))
