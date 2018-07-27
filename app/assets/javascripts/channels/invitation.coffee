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

    $editListOwner = $('[data-edit-list-id= "'+data.list_id+'"]', $currentUserOwner)
    # collaboration user in collaboration user list
    $collaboratorUserOwner = $('[data-chip-user-id= "'+data.recipient+'"]', $collaborationUsersOwner)
    # collaboration user shown in list
    $collaboratorShowInList = $('[data-user-id= "'+data.recipient+'"]', $listOwner)

    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $listCollaborationUsers = $('.list-collaboration-users', $list)
    $pageContentUser = $('[data-user-id = "' + data.recipient + '"]', $list)
    $collaboration_users = $('ul#collaboration-users', $list)

    # list settings
    $editList = $('[data-edit-list-id= "'+data.list_id+'"]')
    $listPendingInvitation = $('[data-list-pending-invitation-id= "' + data.id + '"]', $editList)
    $listMember = $('[data-list-member-id= "' + data.recipient + '"]', $editList)
    $collaboratorUserSettingOwner = $('[data-list-member-id= "'+data.recipient+'"]', $editList)
    $mainCenter = $('#main_center')
    $listMembersSettingList = $('#members ul.ms-members')
    $listPendingInvitationsSettingList = $('#invitations ul.ms-pending-invitations')

    # activated or collaboratorDeleted
    $navUser = $('[data-nav-id = "' + data.recipient + '"]')
    $ulCollaborationList = $('ul#ulCollaborationList', $navUser)
    $ulCreatedList = $('ul#ulCreated', $navUser)
    $addCreatedList = $('li.ms-add', $ulCreatedList)
    $body = $('[data-current-user= "'+data.recipient+'"]')
    $userPendingInvitations = $('#pending-invitations ul',$body)
    $userAcceptedInvitations = $('#accepted-invitations ul',$body)
    $pending_invitation = $('[data-pending-invitation-id= "' + data.id + '"]', $userPendingInvitations)
    $accepted_invitation = $('[data-accepted-invitation-id= "' + data.id + '"]', $userAcceptedInvitations)
    $addMemberToSettingsListOwner = $('#members ul.ms-members', $editListOwner)
    $addInvitationToSettingsListOwner = $('#invitations ul.ms-pending-invitations', $editListOwner)
    switch data.status
      when 'created'
        # Add new  user invited (existen) to the list of collaboration users for the list if owner is login
        if data['existing_user_invite']
          $collaborationUsersOwner.prepend data['htmlCollaborationUser']
        # Add new user invited (existen)to the LIST OF COLLABORATION USERS (MEMBERS) for the list if owner is login in Settings
        $addMemberToSettingsListOwner.prepend data['htmlListMembersSettings']
        $captionM = $('li#caption',$addMemberToSettingsListOwner)
        if ($captionM.length > 0)
            $captionM.remove()
        # Add new pending invitation to the list of pending users for the EDIT LIST if owner is login in Settings
        $addInvitationToSettingsListOwner.prepend data['htmlInvitationSetting']
        $captionI = $('li#caption',$addInvitationToSettingsListOwner)
        if ($captionI.length > 0)
            $captionI.remove()
        # Add new invitation to the list of user pending invitations in USER SETTINGS
        $userPendingInvitations.prepend data['htmlUserPendingInvitation']
        $captionUPI = $('li#caption',$userPendingInvitations)
        if ($captionUPI.length > 0)
            $captionUPI.remove()
      when 'activated'  #revisar
        $listPendingInvitation.remove()
        $pending_invitation.remove()
        $userAcceptedInvitations.prepend data['htmlUserAcceptedInvitation']
        if $collaboratorUserOwner.length > 0
          $collaboratorUserOwner.removeClass("ms-inactive")
          $(".user-img",$collaboratorShowInList).removeClass("ms-inactive")
        else
          $collaboration_users.append data.htmlCollaborationUser
        $collaboratorUserSettingOwner.removeClass("ms-inactive")
        if data.htmlCollaborationsList!= ""
          if data.hasCollaborationsList==false
            $ulCollaborationList.append '<li class="li-hover"><p class="ultra-small margin more-text">Collaboration lists</p></li>'
          $ulCollaborationList.append data.htmlCollaborationsList
      when 'deleted'
        $collaboratorUserSettingOwner.remove()
        $listPendingInvitation.remove()
        $pending_invitation.remove()
      when 'collaboratorDeleted'
        $collaboratorUserList = $('[data-chip-user-id= "'+ data.recipient+'"]', $collaboration_users)
        $collaboratorUserList.remove()
        $pageContentUser.remove()
        $accepted_invitation.remove()
        $pending_invitation.remove()
        if $listPendingInvitation.length > 0
          $listPendingInvitation.remove()
        if ($('li',$listPendingInvitationsSettingList).length == 0)
          console.log data['invitation_caption_html']
          $listPendingInvitationsSettingList.html data['invitation_caption_html']
        if $listMember.length > 0
          $listMember.remove()
        console.log $('li',$listMembersSettingList)
        if ($('li',$listMembersSettingList).length == 0)
          console.log data['member_caption_html']
          $listMembersSettingList.html data['member_caption_html']
        # collaboration user in collaboration user in settings
        $collaboratorUserSettingOwner.remove()
        $collaborationList = $('[data-nav-list-id= "'+data.list_id+'"]', $ulCollaborationList)
        $collaborationList.remove()


      # when 'inactive'
      #   $ulInvitationUserSettings.prepend data['invitationSetting']
