App.invitation = App.cable.subscriptions.create "InvitationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $listCollaborationUsers = $('.list-collaboration-users', $list)
    $collaboration_users = $('ul#collaboration-users', $listCollaborationUsers)
    $add = $('li.ms-add', $collaboration_users )

    $invitation = $('[data-invitation-id= "' + data.id + '"]')
    $editList = $('[data-edit-list-id= "'+data.list_id+'"]')
    $ulCollaborationUserSettings = $('.collaboration-user-settings', $editList)
    $addSettings = $('li.ms-add', $ulCollaborationUserSettings )
    $ulInvitationUserSettings = $('ul.invitation-user-settings', $editList)

    switch data.status
      when 'activated'
        $navUser = $('[data-nav-id = "' + data.recipient + '"]')
        $ul = $('ul#ulCollaboration', $navUser)
        $( data.html ).insertBefore $add
        $invitation.remove()
        $( data.collaboratorSetting ).insertBefore $addSettings
        if data.htmlCollaborationsList!= ""
          if data.hasCollaborationsList==false
             $ul.append '<li class="li-hover"><p class="ultra-small margin more-text">Collaboration lists</p></li>'
          $ul.append data.htmlCollaborationsList
      when 'deleted'
        $invitation.remove()
      when 'inactive'
        $ulInvitationUserSettings.prepend data['invitationSetting']
