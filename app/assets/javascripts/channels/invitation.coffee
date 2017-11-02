App.invitation = App.cable.subscriptions.create "InvitationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

    switch data.status
      when 'activated'
        $pageContent = $('#page-content')
        $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
        $collaboration_users = $('ul#collaboration-users', $list)
        $navUser = $('[data-nav-id = "' + data.recipient + '"]')
        $ul = $('ul#ulCollaboration', $navUser)
        $navleft = $('#left-sidebar-nav')
        $collaboration_users.prepend data['html']
        if data.htmlCollaborationsList!= ""
          if !data.hasCollaborationsList
             $ul.append '<li class="li-hover"><p class="ultra-small margin more-text">Collaboration lists</p></li>'
          $ul.append data.htmlCollaborationsList
      when 'deleted'
        $invitation = $('[data-invitation-id= "' + data.id + '"]')
        $invitation.remove()
        alert('delete')
