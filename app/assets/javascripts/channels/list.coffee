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
          if (data.blocker) && (data.numBlockers == 0)
            alert(data.numBlockers)
            $parentTask = $('[data-task-id = "' + data.parentTask + '"]', $user)
            $('#menu >ul.menu-option li a#link-blocker i', $parentTask).removeClass('md-red').addClass('md-dark md-inactive')
        when 'important'
          if (data.important)
            $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-dark md-inactive').addClass('md-jellow')
          else
            $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-jellow').addClass('md-dark md-inactive')
        when 'deadline'
          if (data.deadline != "") || (data.deadline != "null")
            d = new Date(data.deadline)
            date = d.getShortDayWeek()+ ', ' + d.getDate() + ' ' + d.getShortMonth()
            $('ul.menu-information li.ms-deadline', $task).addClass('active')
            if  $('#menu >ul.menu-option li i#btn-datepicker', $task).hasClass('md-dark md-inactive')
              $('#menu >ul.menu-option li i#btn-datepicker', $task).removeClass('md-dark md-inactive').addClass('md-red')
            $('p#alternate', $task).html(date)
          else
            alert("in null")
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
      deadlineDatepicker()
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
