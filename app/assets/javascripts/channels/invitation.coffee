App.invitation = App.cable.subscriptions.create "InvitationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    alert('activated')
    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $collaboration_users = $('ul#collaboration-users', $list)

    switch data.status
      when 'activated'
        alert(data.list_id)  
        $collaboration_users.prepend data['html']
      when 'deleted'
        alert('delete')
