App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->

    $pageContent = $('#page-content')
    $listUsers = $('#list-users ul', $pageContent )
    $contentUser = $('li[data-user-id = "' + data.user + '"]', $listUsers)
    $contentUserAvatar = $('div.chip.user-img > img', $contentUser)

    $nav = $('[data-nav-id = "' + data.user + '"]')
    $userNavShip = $('li[data-topnavbar-user-id = "' + data.user + '"]')

    $collaborationUsers = $('ul#collaboration-users')
    $liChip = $('[data-chip-user-id = "' + data.user + '"]', $collaborationUsers)
    $collaborationUserAvatar = $('span.member-avatar > img', $liChip )
    $name = '' + data.name + ' changed avatar'

    $body = $('[data-current-user="' + data.user + '"]')
    $userName = $("#dropdown-button-name span", $body)
    $userEmail = $('li.ms-user-email span', $body)
    $userEditPassword = $('form#user_edit_password .ms-form', $body)

    switch data.status
      when 'changeavatar'
        $contentUserAvatar.attr('src',data.image )
        $collaborationUserAvatar.attr('src',data.image )
      when 'changeemail'
        $userEmail.html(data.email)
        $inputEmail = $('input[name="user[email]"]', $userEditPassword)
        $inputEmail.val(data.email)
      when 'changeprofile'
        # $inputName = $('input[name="user[name]"]', $userEditPassword)
        # $inputName.val(data.first_name)
        $userName.html(data.first_name)
