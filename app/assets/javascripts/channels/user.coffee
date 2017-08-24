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
    $barUserInfo = $('.nano-content>ul li.bar-user-info', $nano)
    $barUserAvatar = $('img', $barUserInfo)

    $nav = $('[data-nav-id = "' + data.user + '"]')
    $userNavShip = $('li[data-topnavbar-user-id = "' + data.user + '"]')
    $chipList = $('div.chip> img', $userNavShip)

    $collaborationUsers = $('ul#collaboration-users')
    $liChip = $('[data-chip-user-id = "' + data.user + '"]', $collaborationUsers)
    $collaborationUserAvatar = $('a > img', $liChip )
    $name = '' + data.name + ' changed avatar'

    switch data.status
      when 'changeavatar'
        Materialize.toast($name, 4000);
        $barUserAvatar.attr('src',data.avatar )
        $contentUserAvatar.attr('src',data.avatar )
        $collaborationUserAvatar.attr('src',data.avatar )
        $chipList.attr('src',data.avatar )

        # $('.edit_task').submitOnCheck()
        # deadlineDatepicker($('input.deadline-datepicker'));
        # $('input.deadline-datepicker.hidden-datepicker').hover(handlerIn, handlerOut);
      # when 'deleted'
      #   $task.remove()
      #   if (data.blocker) && (data.numBlockers == 0)
      #     $parentTask = $('[data-task-id = "' + data.parentTask + '"]', $user)
      #     $('#menu >ul.menu-option li a#link-blocker i', $parentTask).removeClass('md-red').addClass('md-dark md-inactive')
      # when 'important'
      #   if (data.important)
      #     $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-dark md-inactive').addClass('md-jellow')
      #   else
      #     $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-jellow').addClass('md-dark md-inactive')
      # when 'deletedeadline'
      #     $('ul.menu-information li.ms-deadline', $task).removeClass('active')
      #     if  !($('#menu >ul.menu-option li i.i-btn-datepicker', $task).hasClass('md-dark md-inactive'))
      #       $('#menu >ul.menu-option li i.i-btn-datepicker', $task).addClass('md-dark md-inactive').removeClass('md-red')
      #     $('p#alternate', $task).html('')
      # when 'deadline'
      #   if (data.deadline != "") || (data.deadline != "null")
      #     d = new Date(data.deadline)
      #     date = d.getShortDayWeek()+ ', ' + d.getDate() + ' ' + d.getShortMonth()
      #     $('ul.menu-information li.ms-deadline', $task).addClass('active')
      #     if  $('#menu >ul.menu-option li i.i-btn-datepicker', $task).hasClass('md-dark md-inactive')
      #       $('#menu >ul.menu-option li i.i-btn-datepicker', $task).removeClass('md-dark md-inactive').addClass('md-red')
      #     $('p#alternate', $task).html(date)
      # when 'changelist'
      #   $task.remove()
      #   if (data.num != '')
      #     $('.bar-number-task', $listNav).html data['num']
      #     $('.bar-number-task', $listChangeNav).html data['num_list_change']
      # when 'completed'
      #   $task.remove()
      #   $('#complete_tasks', $user).prepend data['html']
      #   if ($('.divider', $user).hasClass('no-active'))
      #     $('.divider', $user).removeClass('no-active')
      #   if (data.num != '')
      #     $('.bar-number-task', $listNav).html data['num']
      #   $('.edit_task').submitOnCheck()

  #   $('.dropdown-button').dropdown()
  #   deadlineDatepicker($('input.deadline-datepicker',$list ))
  # else
  #   if data.blocker
  #       $parent = $('[data-task-id = "' + data.parentId + '"]', $user)
  #       $('#show_blockers_' + data.parentId).prepend data['html']
  #       if !($('a#link-blocker > i',$parent).hasClass('md-red'))
  #         $('a#link-blocker > i',$parent).addClass('md-red')
  #         $('a#link-blocker > i',$parent).removeClass('md-inactive')
  #       $('i[data-has-blockers]',$parent).data('data-has-blockers','true')
  #       $('.edit_task').submitOnCheck()
  #
  #   else
  #     $('#incomplete_tasks', $user).prepend data['html']
  #     $('.edit_task').submitOnCheck()
  #     $('#list_user_' + data['user'] + ' .new_task #task_detail').val('');
  #     if (data.num != '')
  #       $('.bar-number-task', $listNav).html data['num']

# submit_task = () ->
# $('#new_task #detail').on 'keydown', (event) ->
#   if event.keyCode is 13
#     $('#new_task #create_task_button').click()
#     event.target.value = ""
#     event.preventDefault()