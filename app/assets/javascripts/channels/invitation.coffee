App.invitation = App.cable.subscriptions.create "InvitationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $currentUserOwner = $('[data-current-user = "' + data.owner + '"]')
    $pageContentOwner = $('#page-content', $currentUserOwner)
    $listOwner = $('[data-list-id = "' + data.list_id + '"]', $pageContentOwner)
    # $listCollaborationUsersOwner = $('.list-collaboration-users', $listOwner)
    $collaborationUsersOwner = $('ul#collaboration-users', $listOwner)
    $addCollaborationUserOwner = $('li.ms-add', $collaborationUsersOwner )

    $editListOwner = $('[data-edit-list-id= "'+data.list_id+'"]', $currentUserOwner)
    $ulCollaborationListUserSettings = $('.collaboration-user-settings', $editListOwner)
    $addCollaborationUserSettingsOwner = $('li.ms-add', $ulCollaborationListUserSettings )
    $ulInvitationUserSettings = $('ul.invitation-user-settings', $editListOwner)
    # collaboration user in collaboration user list
    $collaboratorUserOwner = $('[data-chip-user-id= "'+data.recipient+'"]', $collaborationUsersOwner)
    # collaboration user in collaboration user in settings

    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $listCollaborationUsers = $('.list-collaboration-users', $list)
    $pageContentUser = $('[data-user-id = "' + data.recipient + '"]', $list)

    $collaboration_users = $('ul#collaboration-users', $list)
    $add = $('li.ms-add', $collaboration_users )

    $invitation = $('[data-invitation-id= "' + data.id + '"]')
    $editList = $('[data-edit-list-id= "'+data.list_id+'"]')
    $ulCollaborationListUserSettings = $('.collaboration-user-settings', $editList)
    $addSettings = $('li.ms-add', $ulCollaborationListUserSettings )
    $collaboratorUserSettingOwner = $('[data-collaboration-user-settings-id= "'+data.recipient+'"]', $ulCollaborationListUserSettings)
    # $ulInvitationUserSettings = $('ul.invitation-user-settings', $editList)
    $mainCenter = $('#main_center')

    # activated or collaboratorDeleted
    $navUser = $('[data-nav-id = "' + data.recipient + '"]')
    $ulCollaborationList = $('ul#ulCollaborationList', $navUser)
    $ulCreatedList = $('ul#ulCreated', $navUser)
    $addCreatedList = $('li.ms-add', $ulCreatedList)

    switch data.status
      when 'created'
        if data.existing_user_invite
          # Add new  user invited (existen) to the list of collaboration users for the list if owner is login
          $( data.htmlCollaborationUser ).insertBefore $addCollaborationUserOwner
          # Add new user invited (existen)to the list of collaboration users for the list if owner is login in Settings
          $( data.htmlCollaboratorSetting ).insertBefore $addCollaborationUserSettingsOwner
          # Add new pending invitation to the list of pending users for the edit list if owner is login in Settings

          $ulInvitationUserSettings.prepend data['htmlInvitationSetting']
      when 'activated'  #revisar
        $invitation.remove()
        if $collaboratorUserOwner.length > 0
          $collaboratorUserOwner.removeClass("ms-inactive")
        else
          $collaboration_users.append data.htmlCollaborationUser
        $collaboratorUserSettingOwner.removeClass("ms-inactive")
        if data.htmlCollaborationsList!= ""
          alert(data.hasCollaborationsList)
          if data.hasCollaborationsList==false
            $ulCollaborationList.append '<li class="li-hover"><p class="ultra-small margin more-text">Collaboration lists</p></li>'
          $ulCollaborationList.append data.htmlCollaborationsList
      when 'deleted'
        $invitation.remove()
      when 'collaboratorDeleted'
        $collaboratorUserList = $('[data-chip-user-id= "'+ data.recipient+'"]', $collaboration_users)
        $collaboratorUserList.remove()
        $pageContentUser.remove()
        # collaboration user in collaboration user in settings
        $collaboratorUserSettingOwner.remove()
        $collaborationList = $('[data-nav-list-id= "'+data.list_id+'"]', $ulCollaborationList)
        $collaborationList.remove()


      # when 'inactive'
      #   $ulInvitationUserSettings.prepend data['invitationSetting']
