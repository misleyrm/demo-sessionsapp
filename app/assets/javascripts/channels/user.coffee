App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # alert(data.html);
    $pageContent = $('#page-content')
    $listUsers = $('div#list-users', $pageContent )
    $contentUser = $('[data-user-id = "' + data.user + '"]', $listUsers)
    $contentUserAvatar = $('div.user-img> img', $contentUser)

    $barUser = $('[data-nav-id = "' + data.user + '"]')
    $nano = $('.nano',$barUser)
    $barUserInfo = $('ul#bar-user-informations li.bar-user-info', $nano)
    $barUserAvatar = $('img', $barUserInfo)

    $nav = $('[data-nav-id = "' + data.user + '"]')
    $userNavShip = $('li[data-topnavbar-user-id = "' + data.user + '"]')
    $chipList = $('div.chip> img', $userNavShip)

    $collaborationUsers = $('ul#collaboration-users')
    $liChip = $('[data-chip-user-id = "' + data.user + '"]', $collaborationUsers)
    $collaborationUserAvatar = $('a > img', $liChip )
    $name = '' + data.name + ' changed avatar'

    $body = $('[data-current-user="' + data.user + '"]')
    $userEmail = $('li.ms-user-email span', $body)
    $userEditPassword = $('form#user_edit_password .ms-form', $body)

    switch data.status
      when 'changeavatar'
        # Materialize.toast($name, 4000);
        $barUserAvatar.attr('src',data.avatar )
        $contentUserAvatar.attr('src',data.avatar )
        $collaborationUserAvatar.attr('src',data.avatar )
        $chipList.attr('src',data.avatar )
      when 'changeemail'
        $userEmail.html(data.email)
        $inputEmail = $('input[name="user[email]"]', $userEditPassword)
        $inputEmail.val(data.email)
      when 'changeprofile'
        $inputName = $('input[name="user[name]"]', $userEditPassword)
        $inputName.val(data.name)
        $('a#dropdown-button-name span',$body).html(data.first_name)
