App.list = App.cable.subscriptions.create "ListChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # alert(data.html);
    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $user = $('[data-user-id = "' + data.user + '"]', $list)

    # if data.current_user_id                                       #(data.status == 'changelist') || (data.num != '')
    $nav = $('[data-nav-id = "' + data.user + '"]')
    $listNav = $('[data-list-id = "' + data.list_id + '"]', $nav)
    $listChangeNav = $('[data-list-id = "' + data.list_change + '"]', $nav)
      # $numTask = $('.bar-number-task', $listNav)
    # $('#list_user_' + data['user'] + ' #incomplete_tasks')
    if data.blocker
      $task = $('[data-blocker-id = "' + data.id + '"]')
    else
      $task = $('[data-task-id = "' + data.id + '"]', $user)

    if $task.length > 0
      switch data.status
        when 'saved'
          $task.replaceWith data.html
          $('.edit_task').submitOnCheck()
        when 'deleted'
          $task.remove()
        when 'changelist'
          $task.remove()
          if (data.num != '')
            $('.bar-number-task', $listNav).html data['num']
            $('.bar-number-task', $listChangeNav).html data['num_list_change']
        when 'completed'
          $task.remove()
          $('#complete_tasks', $user).prepend data['html']
          if ($('.divider', $user).hasClass('no-active'))
            $('.divider', $user).removeClass('no-active')
          if (data.num != '')
            $('.bar-number-task', $listNav).html data['num']
          $('.edit_task').submitOnCheck()

      $('.dropdown-button').dropdown()
    else
      if data.blocker
          $parent = $('[data-task-id = "' + data.parentId + '"]', $user)
          $('#show_blockers_' + data.parentId).prepend data['html']
          if !($('a#link-blocker > i',$parent).hasClass('md-red'))
            $('a#link-blocker > i',$parent).addClass('md-red')
            $('a#link-blocker > i',$parent).removeClass('md-inactive')
          $('i[data-has-blockers]',$parent).data('data-has-blockers','true')
          $('.edit_task').submitOnCheck()

      else
        $('#incomplete_tasks', $user).prepend data['html']
        $('.edit_task').submitOnCheck()
        $('#list_user_' + data['user'] + ' .new_task #detail').val('');
        if (data.num != '')
          $('.bar-number-task', $listNav).html data['num']

  submit_task = () ->
  $('#new_task #detail').on 'keydown', (event) ->
    if event.keyCode is 13
      $('#new_task #create_task_button').click()
      event.target.value = ""
      event.preventDefault()
