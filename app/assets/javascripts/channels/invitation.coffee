App.invitation = App.cable.subscriptions.create "InvitationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

    $currentUserOwner = $('[data-current-user = "' + data.owner + '"]')
    $pageContentOwner = $('#page-content', $currentUserOwner)
    $listOwner = $('[data-list-id = "' + data.list_id + '"]', $pageContentOwner)
    $listCollaborationUsersOwner = $('.list-collaboration-users', $listOwner)
    $collaborationUsersOwner = $('ul#collaboration-users', $listCollaborationUsersOwner)
    $addCollaborationUserOwner = $('li.ms-add', $collaborationUsersOwner )
    $editListOwner = $('[data-edit-list-id= "'+data.list_id+'"]', $currentUserOwner)
    $ulCollaborationListUserSettings = $('.collaboration-user-settings', $editList)
    $addCollaborationUserSettingsOwner = $('li.ms-add', $ulCollaborationListUserSettings )
    $collaboratorUserOwner = $('[data-chip-user-id= "'+data.recipient+'"]',$collaborationUsersOwner)

    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $listCollaborationUsers = $('.list-collaboration-users', $list)

    $collaboration_users = $('ul#collaboration-users', $listCollaborationUsers)
    $add = $('li.ms-add', $collaboration_users )

    $invitation = $('[data-invitation-id= "' + data.id + '"]')
    $editList = $('[data-edit-list-id= "'+data.list_id+'"]')
    $ulCollaborationListUserSettings = $('.collaboration-user-settings', $editList)
    $addSettings = $('li.ms-add', $ulCollaborationListUserSettings )
    $ulInvitationUserSettings = $('ul.invitation-user-settings', $editList)



    switch data.status
      when 'created'
        if data.existing_user_invite
          $( data.html ).insertBefore $addCollaborationUserOwner
          # $invitation.remove()
          $( data.collaboratorSetting ).insertBefore $addCollaborationUserSettingsOwner
        else
          $ulInvitationUserSettings.prepend data['invitationSetting']
      when 'activated'
        $navUser = $('[data-nav-id = "' + data.recipient + '"]')
        $ul = $('ul#ulCollaborationList', $navUser)
        $( data.html ).insertBefore $add
        $invitation.remove()
        $collaboratorUserOwner.removeClass("ms-inactive")
        $( data.collaboratorSetting ).insertBefore $addSettings
        if data.htmlCollaborationsList!= ""
          if data.hasCollaborationsList==false
            $ul.append '<li class="li-hover"><p class="ultra-small margin more-text">Collaboration lists</p></li>'
            $ul.append data.htmlCollaborationsList
      when 'deleted'
        $invitation.remove()
      # when 'inactive'
      #   $ulInvitationUserSettings.prepend data['invitationSetting']
